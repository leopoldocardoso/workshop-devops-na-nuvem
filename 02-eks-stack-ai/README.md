# 02-eks-stack-ai

Stack de cluster Amazon EKS, implementada conforme
[ADR-0003](../docs/adr/ADR-0003-eks-stack.md) (ver Seção 13 — Handoff).
Provisiona o control plane EKS, seu Managed Node Group e a fundação de
IAM/observabilidade associada (IAM Roles, CMK dedicada para envelope
encryption de Secrets, CloudWatch Log Group de control plane logging, IAM
OIDC Provider). Composta exclusivamente por recursos **nativos** do
provider `hashicorp/aws` (`~> 6.0`) — nenhum módulo de terceiros/comunidade
é utilizado (ADR-0003 Seção 4).

**Não inclui** (Non-goals explícitos, ADR-0003 Seção 14): add-ons do
cluster geridos via `aws_eks_addon`, AWS Load Balancer Controller,
Cluster Autoscaler/Karpenter, ArgoCD, IAM Roles de IRSA por
workload/service account, Access Entries para outros usuários/times, EKS
Auto Mode/Fargate, autoscaling horizontal de nodes, ou qualquer deploy de
aplicação/manifesto Kubernetes.

**Ambiente único: `prd`.** Mesmo padrão de `00-`/`01-` (Revisão 5 do
ADR-0001): não há `variable "environment"` — `local.environment = "prd"`
é fixo em `locals.tf`.

## Dependência de `01-networking-stack-ai` (ADR-0003 Seção 4, decisão D4)

Esta é a primeira stack do repositório que depende de outra. A VPC e as
sub-redes (2 públicas, 2 privadas) usadas por este cluster **não são
provisionadas aqui** — são consumidas de `01-networking-stack-ai` via
**data sources nativos filtrados por tag** (`data.aws_vpc`,
`data.aws_subnets`, filtrando por `tag:StackName = "01-networking-stack-ai"`,
`tag:Environment = "prd"` e `tag:Tier`), **não** via
`terraform_remote_state`.

Essa decisão (ADR-0003 Seção 4/D4) mantém esta stack desacoplada de onde/
como o state de `01-` é armazenado — funciona tanto com o backend local
quanto com o backend S3 de `01-`, sem qualquer mudança de código. O
trade-off aceito: esta stack depende da estabilidade do esquema de tags de
`01-` (`StackName`, `Environment`, `Tier`) — se removidas/renomeadas em uma
revisão futura de `01-`, o `terraform plan` desta stack falha de forma
clara (data source vazio ou com múltiplos resultados), nunca de forma
silenciosa.

**Pré-requisito bloqueante:** a VPC e as 4 sub-redes de
`01-networking-stack-ai` precisam já estar de fato aplicadas (`terraform
apply` real, não apenas `plan`) antes de qualquer `apply` desta stack —
ver Seção 13.1, passo 0 do ADR-0003.

## Estrutura

Estrutura de arquivos e variáveis em conformidade com
[`.claude/rules/terraform-naming-conventions.md`](../.claude/rules/terraform-naming-conventions.md).

| Arquivo | Conteúdo |
|---|---|
| `main.tf` | Ponto de entrada da stack (nenhum recurso; índice de onde cada domínio está implementado). |
| `versions.tf` | Terraform CLI (`>= 1.15.8`) e provider `hashicorp/aws` (`~> 6.0`, testado com `6.62.0`). |
| `backend.tf` | Backend S3 (configuração parcial, `use_lockfile = true`, `encrypt = true`); `bucket`/`key`/`region` vêm do `backend.hcl` (gitignored, gerado a partir de `backend.hcl.example`). Migrado do backend local em 2026-09-21. |
| `providers.tf` | `provider "aws"` com `default_tags`. |
| `variables.tf` | Variáveis de input agrupadas por domínio (`networking`, `eks_cluster`, `eks_secrets_encryption`, `eks_node_group`) + independentes (`aws_region`, `project_name`, `tags`); nenhuma declara `default`. |
| `data.tf` | `data.aws_vpc.networking`, `data.aws_subnets.private`/`public` (ADR-0003 Seção 4/D4), `data.aws_caller_identity.current`. |
| `locals.tf` | `local.environment = "prd"` (fixo), naming dos recursos, tags comuns (`DataClassification = "confidential"`). |
| `eks.cluster-iam.tf` | IAM Role do cluster + `AmazonEKSClusterPolicy`. |
| `eks.node-iam.tf` | IAM Role do node group + `AmazonEKSWorkerNodePolicy`/`AmazonEKS_CNI_Policy`/`AmazonEC2ContainerRegistryReadOnly`. |
| `eks.encryption.tf` | `aws_kms_key.secrets` (CMK dedicada, rotação anual) + `aws_kms_alias.secrets`. |
| `eks.logging.tf` | `aws_cloudwatch_log_group.cluster` — nome fixo `/aws/eks/{cluster_name}/cluster`, criado antes do cluster. |
| `eks.tf` | `aws_eks_cluster.this` — `version = "1.34"`, endpoint público+privado com CIDR restrito, `encryption_config`, `access_config.authentication_mode = "API"`. |
| `eks.oidc.tf` | `aws_iam_openid_connect_provider.this` — fundação IRSA, sem `thumbprint_list` (IAM resolve automaticamente). |
| `eks.node-group.tf` | `aws_eks_node_group.this` — 2x `t3.medium` `ON_DEMAND`, sub-redes privadas, `node_repair_config.enabled = true`. |
| `outputs.tf` | Outputs para consumo por stacks de workload futuras e validação pós-deploy. |

Arquivo de valores único na raiz da stack, `terraform.tfvars` (gerado a
partir de `terraform.tfvars.example`, ignorado pelo `.gitignore` —
`*.tfvars`, exceto o `.example`).

## Pré-requisitos

- **`01-networking-stack-ai` já aplicada de fato** (VPC + 4 sub-redes em
  estado `available`) — ver seção acima e Seção 13.1 passo 0 do ADR-0003.
- Credenciais AWS configuradas (perfil/role com permissão para
  provisionar EKS (`eks:*` de cluster/node group), IAM (roles, policy
  attachments, OIDC provider), KMS (`kms:CreateKey`, `kms:CreateAlias`,
  `kms:EnableKeyRotation`), CloudWatch Logs, além de `ec2:DescribeVpcs`/
  `DescribeSubnets` para os data sources).
- Terraform CLI `>= 1.15.8`.
- **CIDR(s) reais** de onde o `devops-engineer`/CI acessará o endpoint
  público da API do cluster — variável `eks_cluster.endpoint_public_access_cidrs`
  é obrigatória, sem default, e a validação em `variables.tf` rejeita
  `"0.0.0.0/0"` (ADR-0003 Seção 4/D2). O `terraform.tfvars.example` traz um
  placeholder **inválido de propósito** (`"AJUSTAR-cidr-real/32"`) que
  bloqueia `plan`/`apply` até ser substituído.
- **Confirmação explícita do orçamento estimado** (ADR-0003 Seção 10,
  ~USD 210–275/mês) pelo solicitante antes do `apply` real — critério de
  aceitação (Seção 13.3).

## Uso

```bash
cd 02-eks-stack-ai

# 0) Pré-checagem obrigatória (ADR-0003 Seção 13.1, passo 0) — executar
#    ANTES de prosseguir. Confirmar que o cluster-alvo ainda não existe e
#    que a VPC/sub-redes de 01- existem e estão "available":
aws eks list-clusters --region sa-east-1
aws ec2 describe-vpcs --region sa-east-1 --filters Name=tag:StackName,Values=01-networking-stack-ai Name=tag:Environment,Values=prd
aws ec2 describe-subnets --region sa-east-1 --filters Name=tag:StackName,Values=01-networking-stack-ai

# 1) valores: copiar o exemplo e ajustar CIDR real do endpoint público +
#    Owner/CostCenter (terraform.tfvars é gitignored)
cp terraform.tfvars.example terraform.tfvars
# editar terraform.tfvars — eks_cluster.endpoint_public_access_cidrs, tags

# 2) fmt + init (backend S3 do ADR-0002 — bucket/key/region vêm do backend.hcl)
cp backend.hcl.example backend.hcl   # ajustar bucket e region (us-east-1)
terraform fmt -check
terraform init -backend-config=backend.hcl

# 3) validate
terraform validate

# 4) plan + revisão por pares (OBRIGATÓRIA — ADR-0003 Seção 13.1 passo 5:
#    não há ambiente inferior no repositório e o custo mensal desta stack
#    é o maior entre as 3 stacks existentes). Conferir explicitamente os
#    itens do passo 4 da Seção 13.1: contagem de recursos, data sources
#    não vazios, 5 tipos de log, encryption_config presente,
#    public_access_cidrs sem 0.0.0.0/0, tags obrigatórias.
terraform plan -out=tfplan

# 5) apply somente após revisão do plan E confirmação explícita do
#    orçamento (Seção 13.1 passo 6)
terraform apply tfplan
```

## Validação pós-deploy (ADR Seção 13.4)

```bash
aws eks describe-cluster --name prd-eks-sa-east-1 --region sa-east-1
aws eks list-nodegroups --cluster-name prd-eks-sa-east-1 --region sa-east-1
aws eks describe-nodegroup --cluster-name prd-eks-sa-east-1 --nodegroup-name prd-eks-ng-sa-east-1 --region sa-east-1
aws eks describe-cluster --name prd-eks-sa-east-1 --region sa-east-1 --query "cluster.logging"
aws logs describe-log-groups --log-group-name-prefix /aws/eks/prd-eks-sa-east-1/cluster --region sa-east-1
aws logs describe-log-streams --log-group-name /aws/eks/prd-eks-sa-east-1/cluster --region sa-east-1
aws kms describe-key --key-id alias/prd-eks-secrets-sa-east-1 --region sa-east-1
aws kms get-key-rotation-status --key-id alias/prd-eks-secrets-sa-east-1 --region sa-east-1
aws iam list-open-id-connect-providers
aws ec2 describe-instances --region sa-east-1 --filters Name=tag:aws:eks:cluster-name,Values=prd-eks-sa-east-1
aws resourcegroupstaggingapi get-resources --tag-filters Key=StackName,Values=02-eks-stack-ai --region sa-east-1

terraform plan   # deve retornar "No changes"
```

Validação de conectividade ao endpoint da API (`aws eks update-kubeconfig`
+ `kubectl get nodes`) é aceitável apenas para confirmar que os 2 nodes
aparecem como `Ready` — **não** instalar add-ons/aplicar manifestos como
parte desta validação (fora do escopo, ADR-0003 Seção 14).

## Rollback (ADR Seção 12)

- **Sem `apply` real ainda (cenário mais provável):** `git revert` da
  criação desta stack e/ou simplesmente não aplicar. Nenhuma
  infraestrutura é afetada.
- **Mudanças incrementais pós-criação** (`desired_size`/`max_size` do node
  group, `public_access_cidrs`, retenção de logs): não forçam recriação do
  cluster — `apply` incremental de baixo risco, coberto por
  `update_config.max_unavailable`.
- **Mudanças que forçam recriação completa do cluster** (`# forces
  replacement`): downgrade de `version` (não suportado pelo EKS),
  `encryption_config`, `kubernetes_network_config.service_ipv4_cidr` e,
  dependendo da mudança, `vpc_config.subnet_ids`. Tratar como migração
  planejada, com janela de manutenção — nunca aplicar sem revisão
  explícita por par.
- **Rollback de upgrade de versão do Kubernetes:** mecanismo nativo do
  EKS, suporta rollback para a versão minor anterior dentro de 7 dias após
  a conclusão do upgrade.
- **Node Group:** pode ser destruído e recriado independentemente do
  cluster (não força recriação do `aws_eks_cluster`).
- **State:** desde 2026-09-21 o state fica no bucket S3 do ADR-0002
  (`key = 02-eks-stack-ai/prd/terraform.tfstate`); o `versioning` do
  bucket permite recuperar uma versão anterior do `.tfstate`.
- Sempre rodar `terraform plan` antes de qualquer `apply`/`destroy` de
  correção, prestando atenção especial a qualquer `# forces replacement`
  no `aws_eks_cluster`.

## Pontos de atenção

- **Tags `Owner`/`CostCenter`:** o ADR não define valores definitivos
  ("a definir pelo solicitante" — Seção 9). `locals.tf` usa placeholders
  (`"unassigned"`) que **devem** ser sobrescritos via `var.tags` em
  `terraform.tfvars` antes do apply.
- **`endpoint_public_access_cidrs` é obrigatório e sem default** —
  intencional (fail-safe, ADR-0003 Seção 4/D2/Seção 11): `plan`/`apply`
  falham até um CIDR real ser fornecido, em vez de expor o endpoint sem
  restrição de origem.
- **`encryption_config` não pode ser adicionado depois** a um cluster já
  existente sem recriação completa — confirmar sua presença no `plan` já
  na primeira criação (ADR-0003 Seção 11).
- **NAT Gateway único herdado de `01-` (SPOF em produção, ADR-0001
  Premissa 14)** agora impacta diretamente a capacidade operacional dos
  worker nodes (pull de imagens, chamadas a APIs AWS) — risco herdado e já
  aceito conscientemente em `01-`, não reaberto por esta stack.
- **Sub-redes de `01-` sem tags de descoberta para AWS Load Balancer
  Controller** (`kubernetes.io/role/elb`/`internal-elb`) — não existem
  hoje e não são adicionadas por esta stack (fora do escopo de
  `02-eks-stack-ai`, exigiria revisão de `01-networking-stack-ai`). Uma
  stack/ADR futura de workload que precise de Ingress/LoadBalancer deverá
  tratar isso primeiro.
- **Acoplamento a tags de `01-networking-stack-ai`:** se uma revisão
  futura de `01-` renomear/remover `StackName`/`Environment`/`Tier`, os
  data sources desta stack deixam de encontrar VPC/sub-redes — o `plan`
  falha de forma clara antes de qualquer `apply` incorreto.
- **Ausência de ambiente inferior (`dev`/`hml`):** mesma lacuna herdada de
  `00-`/`01-` — `terraform plan` + revisão por pares obrigatória antes de
  todo `apply`, especialmente crítico aqui dado o custo mensal mais alto
  (~USD 210–275) e a complexidade de IAM/rede envolvida.
- **Custo mensal significativamente maior que `00-`/`01-`** — validar
  explicitamente com o solicitante antes do `apply` real (Seção 13.3).
- **Deleção acidental do cluster:** `aws_eks_cluster.this` (`eks.tf`) teve
  `lifecycle { prevent_destroy = true }` conforme avaliação explicitamente
  delegada ao `devops-engineer` pelo ADR-0003 (Seção 11), **removido em
  2026-08-30** com autorização explícita do operador em sessão (via
  `/terraform-destroy`) para viabilizar um destroy real da stack — ver
  `docs/deployments/02-eks-stack-ai.md` para o registro desse destroy.
  A trava não existe mais no código atual. Se essa proteção for desejada
  novamente (ex.: antes de um próximo apply em `prd`), reintroduzir o
  bloco `lifecycle { prevent_destroy = true }` deliberadamente, em um
  commit próprio e revisado por par — não adicionar/remover "no
  automático" apenas para destravar um `apply`/`destroy`. Independentemente
  da presença ou não desse lifecycle, `terraform destroy`/
  `aws eks delete-cluster` nunca deve ser executado sem confirmação
  explícita em sessão.
- **Backend S3:** migrado em 2026-09-21 (`override.tf` removido,
  `backend.hcl` criado). Como a stack agora tem `backend.hcl`, os drivers
  `terraform-deploy`/`terraform-destroy` a ignoram por padrão — use
  `--allow-remote-apply` para rodar o pipeline contra ela.
