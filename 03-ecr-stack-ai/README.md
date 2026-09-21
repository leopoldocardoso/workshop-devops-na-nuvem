# 03-ecr-stack-ai

Stack de repositórios Amazon ECR, implementada conforme
[ADR-0004](../docs/adr/ADR-0004-ecr-stack.md) (ver Seção 13 — Handoff).
Provisiona **dois repositórios ECR privados** — um para o frontend, um para
o backend — com scanning no push, mutabilidade de tag
`IMMUTABLE_WITH_EXCLUSION` (exceção `latest*`), encriptação `AES256` e uma
lifecycle policy de retenção em cada um. Composta exclusivamente por
recursos **nativos** do provider `hashicorp/aws` (`~> 6.0`) — nenhum
módulo de terceiros/comunidade (ADR-0004 Seção 6.3).

**Não inclui** (Non-goals explícitos, ADR-0004 Seção 14): `docker build`/
`docker push` das imagens de `dvn-workshop-apps/`, deploy de qualquer
Deployment/Service/manifesto Kubernetes no cluster de `02-eks-stack-ai`
(tratado em uma ADR/stack futura, `04-workloads-stack-ai`), IAM Role/
usuário de CI dedicado para push, VPC Endpoint para ECR, replicação
cross-region/cross-account, enhanced scanning (Inspector), política de
repositório (`aws_ecr_repository_policy`), pull-through cache, ou
qualquer alteração em `00-`/`01-`/`02-`.

**Ambiente único: `prd`.** Mesmo padrão de `00-`/`01-`/`02-`: não há
`variable "environment"` — `local.environment = "prd"` é fixo em
`locals.tf`.

## Nome dos repositórios (ADR-0004 Seção 9 — divergência intencional)

| Aplicação | Nome do repositório (`name`) | URL (`repository_url`) |
|---|---|---|
| frontend | `dvn-workshop/production/frontend` | `{account_id}.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend` |
| backend | `dvn-workshop/production/backend` | `{account_id}.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/backend` |

Os nomes seguem **literalmente** o padrão path-style pedido pelo
solicitante, e **não** o padrão de negócio `{env}-{project_name}-{service}-{region}`
usado para o nome dos demais recursos AWS do repositório. Isso é uma
decisão explícita (ADR-0004 Seção 4/D1, Seção 9): o nome de um
repositório ECR é um contrato externo (consumido por `docker push`/`pull`
e pelo campo `image:` de manifestos Kubernetes futuros), não uma tag
`Name` interna. O segmento `production` do path é distinto do valor `prd`
da tag `Environment` — são namespaces conceitualmente diferentes. As
**tags** (`Project`, `StackName`, `Environment` etc.) continuam seguindo o
padrão interno do repositório.

**Não altere `ecr.namespace`/`ecr.environment_segment` após o primeiro
`apply`:** mudar o `name` força recriação do repositório (`# forces
replacement`) e as imagens já publicadas ficam órfãs no repositório
antigo (ADR-0004 Seção 11/12).

## Consumo pelo cluster EKS (ADR-0004 Premissa 7 / 11)

Esta stack **não depende** de `01-`/`02-` a nível de Terraform (nenhum
`data source` cross-stack): criar um repositório ECR não depende de rede
nem do cluster. A única dependência é operacional/IAM: o pull das imagens
pelos worker nodes de `02-eks-stack-ai` já está coberto pela policy
gerenciada `AmazonEC2ContainerRegistryReadOnly` anexada à IAM Role do
node group (`prd-eks-node-role-us-east-1`, ADR-0003) — ela cobre qualquer
repositório ECR da conta, portanto **nenhuma IAM Role/policy nova é
criada aqui** e `02-eks-stack-ai` não é modificada.

## Estrutura

Estrutura de arquivos e variáveis em conformidade com
[`.claude/rules/terraform-naming-conventions.md`](../.claude/rules/terraform-naming-conventions.md).

| Arquivo | Conteúdo |
|---|---|
| `main.tf` | Ponto de entrada da stack (nenhum recurso; índice de onde cada domínio está implementado). |
| `versions.tf` | Terraform CLI (`>= 1.15.8`) e provider `hashicorp/aws` (`~> 6.0`, argumentos validados contra `6.66.0`). |
| `backend.tf` | Backend S3 (configuração parcial, `use_lockfile = true`, `encrypt = true`); `bucket`/`key`/`region` vêm do `backend.hcl` (gitignored, gerado a partir de `backend.hcl.example`). |
| `providers.tf` | `provider "aws"` com `default_tags`. |
| `variables.tf` | Variáveis de input agrupadas por domínio (`ecr`, `ecr_lifecycle`) + independentes (`aws_region`, `project_name`, `tags`); nenhuma declara `default`. |
| `locals.tf` | `local.environment = "prd"` (fixo), nomes path-style dos repositórios, documento JSON da lifecycle policy, tags comuns (`DataClassification = "internal"`). |
| `ecr.tf` | `aws_ecr_repository.frontend` / `.backend` — `IMMUTABLE_WITH_EXCLUSION` (filtro `latest*`), `scan_on_push = true`, `AES256`, `force_delete` default (`false`). |
| `ecr.lifecycle-policy.tf` | `aws_ecr_lifecycle_policy.frontend` / `.backend` — 2 regras (expira não-tageadas > 7 dias; mantém as 10 tageadas mais recentes). |
| `outputs.tf` | Nome, URL e ARN de cada repositório + `registry_id`, para consumo pela futura stack de workloads. |

Arquivo de valores único na raiz da stack, `terraform.tfvars` (gerado a
partir de `terraform.tfvars.example`, ignorado pelo `.gitignore` —
`*.tfvars`, exceto o `.example`).

## Pré-requisitos

- Bucket de state do ADR-0002 (`00-bootstrap-stack-ai`) já existente —
  esta stack nasce diretamente no backend S3 (sem `override.tf`).
- Credenciais AWS configuradas (perfil/role com permissão para
  `ecr:CreateRepository`, `ecr:DescribeRepositories`,
  `ecr:PutImageScanningConfiguration`, `ecr:PutImageTagMutability`,
  `ecr:PutLifecyclePolicy`, `ecr:GetLifecyclePolicy`,
  `ecr:TagResource`/`ListTagsForResource`, `ecr:DeleteRepository`/
  `DeleteLifecyclePolicy` para rollback, além de acesso ao bucket de state).
- Terraform CLI `>= 1.15.8`.
- Valores reais de `Owner`/`CostCenter` em `terraform.tfvars` (os
  placeholders `AJUSTAR-...` do `.example` devem ser substituídos).

## Uso

```bash
cd 03-ecr-stack-ai

# 0) Pré-checagem obrigatória (ADR-0004 Seção 13.1, passo 0): confirmar
#    que nenhum repositório com os nomes-alvo já existe.
aws ecr describe-repositories --region us-east-1 \
  --query "repositories[?starts_with(repositoryName, 'dvn-workshop/')].repositoryName"
# esperado: [] (ou erro RepositoryNotFoundException ao consultar pelos nomes)

# 1) valores: copiar o exemplo e ajustar Owner/CostCenter
cp terraform.tfvars.example terraform.tfvars
# editar terraform.tfvars — tags.Owner / tags.CostCenter

# 2) backend: copiar o exemplo (bucket/key/region já preenchidos)
cp backend.hcl.example backend.hcl

# 3) fmt + init + validate
terraform fmt -check
terraform init -backend-config=backend.hcl
terraform validate

# 4) plan + revisão por pares (OBRIGATÓRIA — ADR-0004 Seção 13.1 passo 5).
#    Conferir explicitamente (passo 4): exatamente 2 aws_ecr_repository +
#    2 aws_ecr_lifecycle_policy; nomes "dvn-workshop/production/frontend"
#    e "dvn-workshop/production/backend"; IMMUTABLE_WITH_EXCLUSION com
#    filtro "latest*"; encryption_type AES256; scan_on_push true; tags
#    obrigatórias incluindo DataClassification = "internal".
terraform plan -out=tfplan

# 5) apply somente após a revisão do plan
terraform apply tfplan
```

Alternativa via driver do repositório (aplica com `-auto-approve`, exige
autorização explícita do operador por invocação; como a stack tem
`backend.hcl`, é necessário `--allow-remote-apply`):

```bash
.claude/skills/terraform-deploy/deploy.sh --allow-remote-apply 03-ecr-stack-ai
```

## Validação pós-deploy (ADR Seção 13.4)

```bash
aws ecr describe-repositories --region us-east-1 \
  --repository-names dvn-workshop/production/frontend dvn-workshop/production/backend
# conferir: imageTagMutability = IMMUTABLE_WITH_EXCLUSION,
#           imageTagMutabilityExclusionFilters[0].filter = latest*,
#           imageScanningConfiguration.scanOnPush = true,
#           encryptionConfiguration.encryptionType = AES256

aws ecr get-lifecycle-policy --region us-east-1 --repository-name dvn-workshop/production/frontend
aws ecr get-lifecycle-policy --region us-east-1 --repository-name dvn-workshop/production/backend
# conferir as 2 regras (untagged > 7 dias; imageCountMoreThan 10 para tagged)

aws ecr get-repository-policy --region us-east-1 --repository-name dvn-workshop/production/frontend
# esperado: RepositoryPolicyNotFoundException (nenhuma política customizada)

aws resourcegroupstaggingapi get-resources --region us-east-1 \
  --tag-filters Key=StackName,Values=03-ecr-stack-ai
# esperado: 2 ARNs de repositório, com todas as tags obrigatórias

terraform plan   # deve retornar "No changes"
```

Teste de pull funcional a partir de um worker node de `02-eks-stack-ai`
é **opcional** e requer uma imagem já publicada manualmente pelo operador
— não faz parte desta entrega.

## Fluxo de push (operacional, fora do escopo Terraform — ADR Premissa 6)

Não há pipeline de CI neste repositório; o push é manual, com a mesma
identidade IAM usada para `terraform apply`:

```bash
REGISTRY="$(terraform output -raw ecr_registry_id).dkr.ecr.us-east-1.amazonaws.com"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$REGISTRY"
docker push "$(terraform output -raw ecr_repository_frontend_url):latest"
docker push "$(terraform output -raw ecr_repository_backend_url):latest"
```

**Apenas tags que casem com `latest*` são sobrescrevíveis.** Qualquer
outra tag (ex.: `v1.2.0`) é imutável após o primeiro push — um novo
`docker push` com a mesma tag falha com `ImageTagAlreadyExistsException`
(comportamento *fail-safe*, ADR-0004 D3/Seção 11). Se uma segunda
convenção de tag mutável for adotada (ex.: `dev-*`), ajuste
`ecr.image_tag_mutability_exclusion_filter` em `terraform.tfvars` e
aplique — não força recriação do repositório.

## Rollback (ADR Seção 12)

- **Sem `apply` real ainda (cenário mais provável):** `git revert` da
  criação desta stack e/ou simplesmente não aplicar. Nenhuma
  infraestrutura é afetada.
- **Ajustar/remover a lifecycle policy:** reversível a qualquer momento,
  sem impacto em imagens já armazenadas — só altera a expiração futura.
- **Alterar `image_tag_mutability`/filtro de exclusão, `scan_on_push`:**
  ajuste incremental, não força recriação.
- **Alterar o `name` de um repositório já aplicado:** força recriação
  completa; imagens não são migradas — tratar como migração planejada
  (novo repositório + republicação manual), nunca como ajuste incremental.
- **Remover um repositório (`terraform destroy`/remoção do bloco):**
  `force_delete` está no default (`false`) — a exclusão é bloqueada
  enquanto houver imagens. **Nunca** definir `force_delete = true` nem
  rodar `terraform destroy` sem confirmação explícita em sessão. O driver
  `.claude/skills/terraform-destroy/destroy.sh` só executa o destroy com
  `--auto-approve` explícito (+ `--allow-remote-apply`, por ser stack com
  `backend.hcl`).
- **State:** no bucket S3 do ADR-0002 (`key =
  03-ecr-stack-ai/prd/terraform.tfstate`); o `versioning` do bucket
  permite recuperar uma versão anterior do `.tfstate`.
- Sempre rodar `terraform plan` antes de qualquer `apply`/`destroy` de
  correção, atentando a `# forces replacement` em `aws_ecr_repository`.

## Pontos de atenção

- **Tags `Owner`/`CostCenter`:** o ADR não define valores definitivos
  (Seção 9 / Premissa 10). `locals.tf` e `terraform.tfvars.example` usam
  placeholders `AJUSTAR-...` que **devem** ser sobrescritos via `var.tags`
  em `terraform.tfvars` antes do apply.
- **Push manual com a identidade ampla de `terraform apply`** (ADR
  Seção 11): não existe role de push dedicada/escopada por repositório.
  CloudTrail registra `ecr:PutImage` etc. por identidade; uma role de CI
  dedicada fica para quando um pipeline real existir (Non-goal).
- **Retenção de 10 imagens tageadas:** se o ritmo de push crescer, um
  rollback para uma versão além da 10ª mais recente exige rebuild a
  partir do código-fonte. `ecr_lifecycle.tagged_keep_count` é ajustável
  sem recriar os repositórios.
- **NAT Gateway único de `01-` (SPOF já aceito):** sem VPC Endpoint para
  ECR, o pull de imagens pelos worker nodes também depende dele — risco
  herdado, não reaberto aqui (ADR Premissa 8 / Seção 11).
- **Ausência de ambiente inferior (`dev`/`hml`):** `terraform plan` +
  revisão por pares obrigatória antes de todo `apply`.
- **Custo:** ~USD 1–2/mês (storage de até 10 versões por repositório;
  transferência intra-região gratuita; scanning básico incluído) —
  marginal frente aos ~USD 145–190/mês de `02-eks-stack-ai` (ADR Seção 10).
- **Drivers `terraform-deploy`/`terraform-destroy`:** como a stack tem
  `backend.hcl`, ambos a ignoram por padrão — use `--allow-remote-apply`.
