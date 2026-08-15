# 01-networking-stack-ai

Stack de rede fundacional (VPC `10.0.0.0/24`), implementada conforme
[ADR-0001](../docs/adr/ADR-0001-networking-stack-vpc.md) (ver Seção 13 —
Handoff). Composta exclusivamente por recursos **nativos** do provider
`hashicorp/aws` (`~> 6.0`) — nenhum módulo de terceiros/comunidade é
utilizado (Seção 5 do ADR).

**Ambiente único: `prd`.** A partir da Revisão 5 do ADR-0001, esta stack
deixou de suportar múltiplos ambientes (`dev`/`hml`/`prd`) e passa a ter um
único ambiente-alvo, `prd`, com NAT Gateway único compartilhado — decisão
de negócio explícita e consciente do solicitante, que reverte a
recomendação de HA completa que este ADR fazia para produção até a
Revisão 4 (ver Premissa 14 e Seção 11 do ADR-0001 para o trade-off de
confiabilidade aceito).

## Estrutura

Estrutura de arquivos e variáveis em conformidade com
[`.claude/rules/terraform-naming-conventions.md`](../.claude/rules/terraform-naming-conventions.md).
Cada arquivo `vpc.*.tf` representa um sub-domínio da VPC; nenhum recurso,
CIDR, flag ou comportamento de infraestrutura foi alterado pela Revisão 5
do [ADR-0001](../docs/adr/ADR-0001-networking-stack-vpc.md) — apenas a
remoção da variável `environment` (agora um `local` fixo) e a mudança de
*valor* da estratégia de NAT Gateway em `prd`.

| Arquivo | Conteúdo |
|---|---|
| `main.tf` | Ponto de entrada da stack (nenhum recurso; índice de onde cada domínio está implementado). |
| `versions.tf` | Terraform CLI (`>= 1.15.8`, ultima versao estavel) e provider `hashicorp/aws` (`~> 6.0`, testado com `6.55.0`, tambem a ultima versao estavel). |
| `backend.tf` | Backend S3 (configuração parcial, `use_lockfile = true`). |
| `providers.tf` | `provider "aws"` com `default_tags`. |
| `variables.tf` | Variáveis de input agrupadas por domínio (`vpc`, `nat_gateway`, `flow_logs`) + independentes (`aws_region`, `project_name`, `tags`); nenhuma declara `default`. **(Revisão 5)** `environment` não é mais uma variável — ver `locals.tf`. |
| `data.tf` | `data "aws_availability_zones"`. |
| `locals.tf` | Naming, tags comuns e cálculo dos CIDRs `/26` via `cidrsubnet()`. **(Revisão 5)** `local.environment = "prd"` (fixo). |
| `vpc.tf` | `aws_vpc`, `aws_default_security_group`, `aws_default_network_acl`. |
| `vpc.public-subnets.tf` | 2 `aws_subnet` públicas (1 por AZ). |
| `vpc.private-subnets.tf` | 2 `aws_subnet` privadas (1 por AZ). |
| `vpc.route-tables.tf` | `aws_internet_gateway`, `aws_route_table`, `aws_route`, `aws_route_table_association`. |
| `vpc.nat-gateway.tf` | `aws_eip`, `aws_nat_gateway`. |
| `vpc.flow-logs.tf` | IAM Role/Policy, CloudWatch Log Group e `aws_flow_log`. |
| `outputs.tf` | Outputs para consumo por stacks futuras (nomes no padrão `{name}_{type}_{attribute}`). |

**(Revisão 5)** Arquivo de valores único na raiz da stack, `terraform.tfvars`
(gerado a partir de `terraform.tfvars.example`, ignorado pelo `.gitignore` —
`*.tfvars`, exceto o `.example`). O diretório `envs/` (que antes continha
`dev.tfvars`, `hml.tfvars` e `prd.tfvars`) **não existe mais** — não há mais
fluxo de promoção entre ambientes.

`terraform.tfvars` (promovido de `envs/prd.tfvars`) já foi validado com
`terraform plan` (backend local temporário, descartado após o teste) contra
a conta AWS configurada neste ambiente: o plano do único ambiente `prd`
totaliza ~22 recursos (NAT Gateway único, sem a HA que antes acrescentava
4 recursos). **Antes do apply real**, ajuste os placeholders
`Owner`/`CostCenter` (`"AJUSTAR-..."`) em `terraform.tfvars` para os valores
reais do time responsável (ADR-0001 Seção 9 — ainda não definidos pelo
solicitante).

## Pré-requisitos

- Bucket S3 do backend de state já existente, com `versioning` e `SSE`
  habilitados (fora do escopo desta stack — Premissa 8 do ADR-0001).
- Credenciais AWS configuradas (perfil/role com permissão para provisionar
  VPC, EC2 (subnets/route tables/NAT/EIP/IGW), IAM (role/policy) e
  CloudWatch Logs).
- Terraform CLI `>= 1.15.8` (ultima versao estavel em 2026-07-19; ver `versions.tf`).

## Uso

```bash
cd 01-networking-stack-ai

# 1) backend: copiar o exemplo e ajustar o bucket real (nao versionado, ver
#    .gitignore). terraform.tfvars ja existe (tambem nao versionado) —
#    apenas ajuste Owner/CostCenter (placeholders "AJUSTAR-...") antes do
#    apply real.
cp backend.hcl.example backend.hcl
# editar backend.hcl (bucket real do backend S3)

# 2) init com backend parcial injetado via -backend-config
terraform init -backend-config=backend.hcl

# 3) fmt + validate
terraform fmt -check
terraform validate

# 4) plan + revisão por pares (obrigatório nesta revisão — não há mais
#    ambiente inferior (dev/hml) para absorver um erro de configuração
#    antes de impactar prd diretamente; ADR-0001 Premissa 16 / Seção 13.1
#    passo 13). terraform.tfvars na raiz é carregado automaticamente, sem
#    necessidade de -var-file.
terraform plan -out=tfplan

# 5) apply somente após revisão do plan
terraform apply tfplan
```

## Validação pós-deploy (ADR Seção 13.4)

```bash
aws ec2 describe-vpcs --filters Name=cidr,Values=10.0.0.0/24
aws ec2 describe-subnets --filters Name=vpc-id,Values=<vpc_id>
aws ec2 describe-route-tables --filters Name=vpc-id,Values=<vpc_id>
aws ec2 describe-nat-gateways --filter Name=vpc-id,Values=<vpc_id>   # deve retornar exatamente 1
aws logs describe-log-groups --log-group-name-prefix /aws/vpc-flow-log/
aws resourcegroupstaggingapi get-resources --tag-filters Key=Environment,Values=prd
terraform plan   # deve retornar "No changes"
```

## Rollback (ADR Seção 12)

- **Sem `apply` real ainda (cenário mais provável desta revisão — Premissa
  7):** `git revert` do commit que removeu `dev`/`hml`, a variável
  `environment` e alterou a estratégia de NAT de `prd`, seguido de novo
  `terraform plan`. Nenhuma infraestrutura é afetada.
- **Se `prd` já tiver sido aplicado com NAT único e for necessário reverter
  para HA (ou vice-versa):** não força recriação da VPC nem das sub-redes —
  apenas cria/destrói o segundo `aws_eip`/`aws_nat_gateway`/`aws_route_table`
  privado. Basta ajustar `nat_gateway.single_nat_gateway`/
  `one_nat_gateway_per_az` em `terraform.tfvars`, seguido de
  `terraform plan`/`apply` em janela de baixo tráfego.
- **Se `cidr_block` precisar reverter:** como é imutável em `aws_vpc`, esse
  rollback força destruição e recriação completas da VPC — tratar como
  migração, não como reversão de configuração.
- **Com stacks dependentes (compute, dados etc. consumindo os outputs
  desta stack) — cenário futuro:** `terraform destroy` completo **não é
  seguro**. Reverter via plano incremental, nunca destruição total.
- Manter `versioning` habilitado no bucket S3 do backend permite recuperar
  uma versão anterior do `.tfstate`, se necessário.
- Sempre rodar `terraform plan` antes de qualquer `apply`/`destroy` de
  correção, prestando atenção especial se o plano indica
  `# forces replacement` no `aws_vpc`.

## Pontos de atenção

- **Tags `Owner`/`CostCenter`:** o ADR não define valores definitivos
  ("a definir pelo solicitante" — Seção 9). `locals.tf` usa placeholders
  (`"unassigned"`) que **devem** ser sobrescritos via `var.tags` em
  `terraform.tfvars` antes do apply.
- **Sobreposição de CIDR:** `10.0.0.0/24` está dentro da faixa
  `10.0.0.0/8`, extremamente comum em redes corporativas on-premises, VPNs
  e outras VPCs AWS. Validar, antes do `apply`, que não há/haverá VPN
  Site-to-Site, VPC Peering ou Transit Gateway conectando esta VPC a redes
  que usem essa faixa (Risco — Seção 11 do ADR).
- **NACL default:** mantida em modo *allow-all* (replicando o padrão da
  AWS), gerenciada explicitamente via `aws_default_network_acl`. NACLs
  dedicadas por sub-rede estão fora de escopo (Seção 14 do ADR).
- **NAT Gateway único, agora em produção:** a partir desta revisão, NAT
  único é a configuração fixa e definitiva do único ambiente da stack
  (`prd`) — não mais um "default dev/hml". Isso é um ponto único de falha
  em produção, aceito conscientemente pelo solicitante (Premissa 14,
  Seção 11 do ADR). A flag `one_nat_gateway_per_az = true` (com
  `single_nat_gateway = false`) permanece disponível no código como
  caminho de reversão futura para HA, sem mudança de arquitetura.
- **Ausência de ambiente inferior para pré-validação:** com a remoção de
  `dev`/`hml`, não há mais um ambiente de teste próprio desta stack.
  Mudanças passam a depender exclusivamente de `terraform plan` + revisão
  por pares obrigatória contra o único ambiente existente (`prd`) —
  Premissa 16 / Seção 11 do ADR.
- **Backend S3:** o bucket em si não é criado por esta stack. `terraform
  init` falhará se o bucket informado em `-backend-config` não existir.
