# 00-bootstrap-stack-ai

Stack de bootstrap do backend remoto de Terraform, implementada conforme
[ADR-0002](../docs/adr/ADR-0002-bootstrap-stack-remote-backend.md) (ver
Seção 13 — Handoff). Único propósito: provisionar o bucket S3
(versionado, criptografado, sem acesso público) que servirá de backend
remoto para `01-networking-stack-ai` e para todas as stacks numeradas
futuras deste repositório. Composta exclusivamente por recursos **nativos**
do provider `hashicorp/aws` (`~> 6.0`) — nenhum módulo de
terceiros/comunidade é utilizado (ADR-0002 Seção 6.3).

**Ambiente único: `prd`.** Mesmo padrão de `01-networking-stack-ai`
(Revisão 5 do ADR-0001): não há `variable "environment"` — `local.environment
= "prd"` é fixo em `locals.tf` (ADR-0002 Premissa 1).

## Por que o backend desta stack é LOCAL PERMANENTE

Diferente de `01-networking-stack-ai` (que tem um `backend.tf` parcial
aguardando migração futura para S3), esta stack **nunca** migra seu próprio
`.tfstate` para o bucket que ela mesma cria. Por definição de dependência
(`00-` roda antes de `01-`), esta stack não pode depender do backend S3 que
está criando — seria uma dependência circular (ADR-0002 Seção 1, Seção 4
decisão D3).

**Consequência prática:** não existe (e não deve ser criado) nenhum
`backend.tf` com bloco `backend "s3"` nesta stack — apenas o `override.tf`
(gitignored), que força backend local indefinidamente. O `.tfstate` local
resultante deve ser tratado como artefato crítico: recomenda-se cópia de
segurança periódica em local seguro fora do repositório Git (ex.: cofre de
segredos da organização) — recomendação operacional, não implementada via
Terraform (ADR-0002 Seção 11/14).

## Estrutura

Estrutura de arquivos e variáveis em conformidade com
[`.claude/rules/terraform-naming-conventions.md`](../.claude/rules/terraform-naming-conventions.md).

| Arquivo | Conteúdo |
|---|---|
| `main.tf` | Ponto de entrada da stack (nenhum recurso; índice de onde cada domínio está implementado). |
| `versions.tf` | Terraform CLI (`>= 1.15.8`) e provider `hashicorp/aws` (`~> 6.0`, validado com `6.60.0` via `terraform-mcp get_latest_provider_version`). |
| `override.tf` | Backend **local permanente** (gitignored). Nenhum `backend.tf` com bloco `backend "s3"` existe nesta stack. |
| `providers.tf` | `provider "aws"` com `default_tags`. |
| `variables.tf` | Variáveis de input agrupadas por domínio (`state_bucket`) + independentes (`aws_region`, `project_name`, `tags`); nenhuma declara `default`. |
| `data.tf` | `data "aws_caller_identity" "current"` (Account ID, usado no nome do bucket). |
| `locals.tf` | `local.environment = "prd"` (fixo), naming do bucket (`{env}-{project_name}-tfstate-{account_id}-{region}`), tags comuns. |
| `state-bucket.tf` | `aws_s3_bucket.this`, `aws_s3_bucket_ownership_controls.this` (`BucketOwnerEnforced`). |
| `state-bucket.versioning.tf` | `aws_s3_bucket_versioning.this` (`Enabled`). |
| `state-bucket.encryption.tf` | `aws_s3_bucket_server_side_encryption_configuration.this` (SSE-S3/`AES256`). |
| `state-bucket.public-access-block.tf` | `aws_s3_bucket_public_access_block.this` (4 flags `true`). |
| `state-bucket.policy.tf` | `data "aws_iam_policy_document" "state_bucket"` + `aws_s3_bucket_policy.this` — nega tráfego sem TLS, nega `PutObject` sem SSE-S3, nega principals fora da conta AWS atual. |
| `state-bucket.lifecycle.tf` | `aws_s3_bucket_lifecycle_configuration.this` — expira versões não-atuais + aborta multipart upload incompleto. |
| `outputs.tf` | `state_bucket_id`, `state_bucket_arn`. |

Arquivo de valores único na raiz da stack, `terraform.tfvars` (gerado a
partir de `terraform.tfvars.example`, ignorado pelo `.gitignore` —
`*.tfvars`, exceto o `.example`).

**Antes do apply real**, ajuste os placeholders `Owner`/`CostCenter`
(`"AJUSTAR-..."`) em `terraform.tfvars` para os valores reais do time
responsável (ADR-0002 Seção 9 — ainda não definidos pelo solicitante).

## Pré-requisitos

- Credenciais AWS configuradas (perfil/role com permissão para provisionar
  recursos S3: `s3:CreateBucket`, `s3:PutBucketVersioning`,
  `s3:PutEncryptionConfiguration`, `s3:PutBucketPublicAccessBlock`,
  `s3:PutBucketPolicy`, `s3:PutLifecycleConfiguration`,
  `s3:PutBucketOwnershipControls`, `s3:PutBucketTagging`, além de
  `sts:GetCallerIdentity`).
- Terraform CLI `>= 1.15.8`.
- **Pré-checagem obrigatória (ADR-0002 Seção 13.1, passo 0)** antes de
  qualquer `apply`: confirmar que o bucket-alvo ainda não existe
  (`aws s3api list-buckets` / `head-bucket`) e que
  `01-networking-stack-ai/override.tf` ainda está presente (backend local,
  não migrado).

## Uso

```bash
cd 00-bootstrap-stack-ai

# terraform.tfvars já existe (gitignored) — apenas ajuste Owner/CostCenter
# (placeholders "AJUSTAR-...") antes do apply real.

# 1) fmt + init (backend LOCAL via override.tf, sem -backend-config)
terraform fmt -check
terraform init

# 2) validate
terraform validate

# 3) plan + revisão por pares (obrigatório — ADR-0002 Seção 13.1 passo 5:
#    um erro aqui, ex. política de bucket incorreta, pode expor o state de
#    TODAS as stacks futuras). terraform.tfvars na raiz é carregado
#    automaticamente, sem necessidade de -var-file.
terraform plan -out=tfplan

# 4) apply somente após revisão do plan (ADR-0002 Seção 13.1 passo 6)
terraform apply tfplan
```

## Nome do bucket e convenção de `key` para stacks consumidoras

Nome do bucket resolvido dinamicamente
(`local.bucket_name`, `locals.tf`), seguindo a extensão da naming
convention do projeto para nomes globalmente únicos (ADR-0002 Seção 9):

```
{env}-{project_name}-tfstate-{account_id}-{region}
-> prd-bootstrap-tfstate-<ACCOUNT_ID>-sa-east-1
```

Exposto via output `state_bucket_id` após o `apply`. Stacks consumidoras
(`01-networking-stack-ai` e futuras) devem referenciar esse nome em seu
próprio `backend.hcl`, usando a convenção de `key` já refletida em
`01-networking-stack-ai/backend.hcl.example`:

```
key = "{stack_dir}/{env}/terraform.tfstate"
# ex.: 01-networking-stack-ai/prd/terraform.tfstate
```

> **Nenhuma stack consumidora é migrada para este backend como parte desta
> entrega.** A migração de `01-networking-stack-ai` (remoção de seu
> `override.tf`, `terraform init -migrate-state`) é uma tarefa subsequente e
> separada, fora do escopo do ADR-0002 (Seção 14), que exige autorização
> explícita própria.

## Validação pós-deploy (ADR-0002 Seção 13.4)

```bash
BUCKET="<state_bucket_id do output>"

aws s3api get-bucket-versioning --bucket "$BUCKET"                # Status: Enabled
aws s3api get-bucket-encryption --bucket "$BUCKET"                 # SSEAlgorithm: AES256
aws s3api get-public-access-block --bucket "$BUCKET"                # 4 flags true
aws s3api get-bucket-policy-status --bucket "$BUCKET"                # IsPublic: false
aws s3api get-bucket-policy --bucket "$BUCKET"                       # 3 clausulas de negacao (TLS, SSE, conta)
aws s3api get-bucket-lifecycle-configuration --bucket "$BUCKET"     # expiracao de versoes + abort multipart
aws s3api get-bucket-ownership-controls --bucket "$BUCKET"          # ObjectOwnership: BucketOwnerEnforced
aws resourcegroupstaggingapi get-resources --tag-filters Key=StackName,Values=00-bootstrap-stack-ai

terraform plan   # deve retornar "No changes"
```

**Não** rodar `terraform init -backend-config` em `01-networking-stack-ai`
como parte desta validação — fora do escopo (ADR-0002 Seção 14).

## Rollback (ADR-0002 Seção 12)

- **Nenhum `apply` real ainda (cenário mais provável):** `git revert` da
  criação desta stack e/ou simplesmente não aplicar. Nenhuma infraestrutura
  é afetada.
- **Bucket já criado, mas nenhuma stack consumidora migrou seu backend para
  ele ainda:** seguro remover via `terraform destroy` **desta stack**
  (backend local) — não há dependência downstream real até que
  `01-networking-stack-ai` (ou outra) tenha efetivamente migrado seu
  backend.
- **Uma ou mais stacks já migraram seu backend para este bucket:**
  `terraform destroy` **não é seguro** — destruiria o state necessário para
  gerenciar essas stacks. Qualquer mudança de configuração do bucket
  (política, lifecycle, criptografia) deve ser aplicada de forma
  incremental; o nome do bucket, uma vez em uso por backends reais, **não
  deve ser alterado**.
- **Recuperação de uma versão corrompida/sobrescrita de um `.tfstate`
  específico:** ação manual via CLI S3 (`aws s3api list-object-versions` +
  `aws s3api get-object --version-id`) — não é uma operação Terraform.
- **Validação pré-rollback:** sempre rodar `terraform plan` antes de
  qualquer `apply`/`destroy` de correção, prestando atenção especial a
  qualquer `# forces replacement` em `aws_s3_bucket.this` (recriação
  implicaria um nome de bucket novo, quebrando todas as `key`s de backend
  já configuradas nas stacks consumidoras).

## Pontos de atenção

- **Tags `Owner`/`CostCenter`:** o ADR não define valores definitivos ("a
  definir pelo solicitante" — Seção 9, Premissa 13). `locals.tf` usa
  placeholders (`"unassigned"`) que **devem** ser sobrescritos via
  `var.tags` em `terraform.tfvars` antes do apply.
- **State local desta própria stack (D3):** reside apenas no disco de
  quem/o que rodou o `apply` — sem versionamento/durabilidade do S3. Trate
  como artefato crítico; recomenda-se cópia de segurança externa periódica
  (fora do escopo Terraform desta entrega).
- **`force_destroy = false`:** intencional (Seção 11) — impede
  `terraform destroy` deste bucket enquanto contiver objetos.
- **Sem IAM dedicado:** esta stack não cria roles/policies de execução
  Terraform para engenheiros/CI que consumirão o bucket — usa as mesmas
  credenciais administrativas já usadas para `01-networking-stack-ai`
  (Non-goal, ADR-0002 Seção 14).
- **Sem logging/auditoria de acesso ao bucket** (S3 Server Access Logging /
  CloudTrail data events) nesta revisão — Non-goal explícito (Seção 8/14).
- **Migração de `01-networking-stack-ai` para este backend é fora de
  escopo** desta entrega — tarefa subsequente e separada, que exige
  autorização explícita própria (ADR-0002 Seção 14).
