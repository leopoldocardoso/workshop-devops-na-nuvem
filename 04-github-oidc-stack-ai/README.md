# 04-github-oidc-stack-ai

Fundação de identidade da esteira de CI: **OIDC identity provider do GitHub Actions + IAM Role + policy de menor privilégio para ECR**.

- **ADR de referência:** [`docs/adr/ADR-0005-github-oidc-iam-roles-ci.md`](../docs/adr/ADR-0005-github-oidc-iam-roles-ci.md) (Status `Approved`, **Revisão 1** de 2026-09-22)
- **Ambiente:** `prd` (único — fixo em `locals.tf`, sem `variable "environment"`)
- **Região:** `us-east-1` (IAM é global; a região compõe os nomes de negócio e a leitura dos repositórios ECR)
- **Custo:** USD 0,00 — IAM, OIDC provider e `sts:AssumeRoleWithWebIdentity` não têm cobrança

## O que esta stack cria

| Recurso | Nome | Observação |
|---|---|---|
| `aws_iam_openid_connect_provider.this` | `prd-github-oidc-us-east-1` (tag `Name`) | `url = https://token.actions.githubusercontent.com`, `client_id_list = ["sts.amazonaws.com"]`, **sem `thumbprint_list`** (ADR Premissa 5). Único por conta. |
| `aws_iam_role.ecr` | `prd-github-oidc-ecr-role-us-east-1` | Trust policy `sts:AssumeRoleWithWebIdentity`, condições em `aud` + `sub`; `max_session_duration = 3600`. |
| `aws_iam_policy.ecr` | `prd-github-oidc-ecr-policy-us-east-1` | Customer managed, push/pull escopado por ARN nos 2 repositórios de `03-`. |
| `aws_iam_role_policy_attachment.ecr` | — | Liga a policy à role. |

Lê (somente leitura) os repositórios `dvn-workshop/production/frontend` e `dvn-workshop/production/backend` criados por `03-ecr-stack-ai` — **esta stack não altera `00-`/`01-`/`02-`/`03-`**.

## A condição `sub` é um controle de fronteira (ADR Seção 8, nota da Revisão 1)

A trust policy aceita **exatamente duas** strings de `sub`, ambas restritas a `ref:refs/heads/main`:

```
repo:leopoldocardoso/workshop-devops-na-nuvem:ref:refs/heads/main
repo:leopoldocardoso@*/workshop-devops-na-nuvem@*:ref:refs/heads/main
```

A primeira é o formato clássico do claim; a segunda é o formato **imutável** adotado pelo GitHub para repositórios criados a partir de 15/07/2026 (ADR Premissa 2). O `@*` aparece **apenas** onde o GitHub insere IDs numéricos, depois do nome literal do owner/repo — **nunca** como curinga de owner.

O repositório é **público durante o laboratório** (ADR Premissa 1): qualquer pessoa pode forkar e abrir PR. Por isso o fragmento `:ref:refs/heads/main` deixou de ser higiene e passou a ser a barreira entre uma contribuição externa e o registry de `prd`.

> **Alargar essa condição** (`repo:owner/repo:*`, incluir `pull_request`, remover uma das entradas) **é mudança de segurança**, tratada em revisão própria do ADR-0005 — nunca um ajuste para "destravar" um pipeline. Ver `iam.ecr-role.tf` e ADR Seção 11.

## Permissões concedidas

| Sid | Ações | Resource |
|---|---|---|
| `EcrAuthToken` | `ecr:GetAuthorizationToken` | `*` (a ação não suporta escopo de recurso — limitação documentada do serviço) |
| `EcrPushPull` | `BatchCheckLayerAvailability`, `InitiateLayerUpload`, `UploadLayerPart`, `CompleteLayerUpload`, `PutImage`, `BatchGetImage`, `GetDownloadUrlForLayer`, `DescribeImages`, `DescribeRepositories`, `ListImages` | ARNs dos 2 repositórios de `03-` |

Nenhuma ação destrutiva (`ecr:BatchDeleteImage`, `ecr:DeleteRepository`, `ecr:Put*Policy`, `ecr:Set*Policy`), nenhum `ecr:*`, nenhum `iam:*`/`sts:*` adicional, nenhum `eks:*`/`s3:*`. Permissões de CI para `terraform plan/apply` e `kubectl` são Non-goals (ADR Seção 14).

## Estrutura

```
04-github-oidc-stack-ai/
├── main.tf                  # índice da stack (sem recursos)
├── versions.tf              # Terraform >= 1.15.8; hashicorp/aws ~> 6.0
├── backend.tf               # backend S3 (configuração parcial)
├── backend.hcl.example      # bucket/key/region -> copiar para backend.hcl (gitignored)
├── providers.tf             # provider aws + default_tags
├── variables.tf             # inputs agrupados em object(...), sem default
├── terraform.tfvars.example # valores -> copiar para terraform.tfvars (gitignored)
├── locals.tf                # environment fixo, nomes, os 2 formatos de `sub`, tags
├── data.tf                  # caller identity + 2 data.aws_ecr_repository
├── oidc.tf                  # aws_iam_openid_connect_provider
├── iam.ecr-role.tf          # trust policy + role + policy + attachment
└── outputs.tf               # ARNs do provider e da role
```

## Pré-requisitos

- `00-bootstrap-stack-ai` aplicado (bucket de state).
- `03-ecr-stack-ai` aplicado — os dois repositórios ECR **precisam existir**, senão os data sources falham no `plan`.
- Credencial AWS com permissão de IAM (create role/policy/OIDC provider) na conta `659942169599`.

## Uso

```bash
cd 04-github-oidc-stack-ai

# 0) Pré-checagem obrigatória (ADR Seção 13.1, passo 0)
aws ecr describe-repositories --region us-east-1 \
  --repository-names dvn-workshop/production/frontend dvn-workshop/production/backend \
  --query 'repositories[].repositoryArn'
aws iam list-open-id-connect-providers
#    Se já existir um provider para token.actions.githubusercontent.com,
#    IMPORTAR em vez de criar (o apply falharia com EntityAlreadyExists):
#    terraform import aws_iam_openid_connect_provider.this \
#      arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com

# 1) valores
cp terraform.tfvars.example terraform.tfvars
cp backend.hcl.example backend.hcl

# 2) fmt + init + validate
terraform fmt -check
terraform init -backend-config=backend.hcl
terraform validate

# 3) plan + revisão por pares (OBRIGATÓRIA em prd — ADR Seção 13.1 passo 4)
terraform plan -out=tfplan
#    Conferir explicitamente no plan:
#    - client_id_list = ["sts.amazonaws.com"] e NENHUM thumbprint_list;
#    - assume_role_policy com StringEquals em :aud e StringLike em :sub
#      contendo EXATAMENTE as 2 strings acima, ambas com refs/heads/main;
#    - policy sem ecr:*, sem delete, Resource "*" só em GetAuthorizationToken;
#    - tags obrigatórias, incluindo DataClassification = "confidential".

# 4) apply somente após a revisão do plan
terraform apply tfplan
```

Ou, via driver (a stack tem `backend.hcl`, portanto exige `--allow-remote-apply`, e o driver aplica com `-auto-approve` — só invoque com autorização explícita do operador):

```bash
.claude/skills/terraform-deploy/deploy.sh --allow-remote-apply 04-github-oidc-stack-ai
```

## Passo manual residual (não coberto por Terraform)

Depois do apply, o operador cria a **repository variable** no GitHub com o ARN da role — é o único elo fora do IaC, porque esta stack não gerencia recursos do GitHub (o provider `integrations/github` não é usado no repositório):

```bash
terraform output -raw github_oidc_ecr_role_arn
# GitHub > Settings > Secrets and variables > Actions > Variables > New repository variable
#   Name : AWS_ROLE_ARN
#   Value: arn:aws:iam::659942169599:role/prd-github-oidc-ecr-role-us-east-1
```

Os workflows do ADR-0007 consomem esse valor como `${{ vars.AWS_ROLE_ARN }}`. É uma **variable**, não um secret: um ARN não autentica nada por si (ADR Seção 8).

## Validação pós-deploy (ADR Seção 13.4)

```bash
# Provider OIDC sem thumbprint e com a audiência correta
aws iam get-open-id-connect-provider \
  --open-id-connect-provider-arn "$(terraform output -raw github_oidc_provider_arn)"

# Trust policy: conferir as 2 entradas de sub e o StringEquals de aud
aws iam get-role --role-name "$(terraform output -raw github_oidc_ecr_role_name)" \
  --query 'Role.AssumeRolePolicyDocument'

# Policy de ECR: conferir ações e ARNs escopados
POLICY_ARN="$(terraform output -raw github_oidc_ecr_policy_arn)"
aws iam get-policy-version --policy-arn "$POLICY_ARN" \
  --version-id "$(aws iam get-policy --policy-arn "$POLICY_ARN" --query 'Policy.DefaultVersionId' --output text)"
```

- **Teste 1 (identidade):** workflow `workflow_dispatch` em `main`, com `permissions: { id-token: write, contents: read }` → `aws sts get-caller-identity` retorna `arn:aws:sts::<account>:assumed-role/prd-github-oidc-ecr-role-us-east-1/...`.
- **Teste 2 (login ECR):** `aws ecr get-login-password --region us-east-1 | docker login ...` no runner → sucesso.
- **Teste 3 (push permitido):** push de imagem com tag descartável em `dvn-workshop/production/frontend` → sucesso.
- **Teste 4 (negativa de escopo):** `aws ecr delete-repository --repository-name dvn-workshop/production/frontend` com a credencial do runner → **AccessDenied esperado**.
- **Teste 5 (negativa de branch):** o mesmo workflow em `test/oidc-negativo` → falha de `AssumeRoleWithWebIdentity`. **Re-executar após qualquer edição da trust policy** — é a evidência do controle de fronteira.
- **Teste 6 (auditoria):** evento `AssumeRoleWithWebIdentity` no CloudTrail Event history, com o `sub` (repo + branch) no `userIdentity`.

Se o Teste 1 falhar por `Not authorized to perform sts:AssumeRoleWithWebIdentity`, inspecione o `sub` real do token (CloudTrail do erro ou job de debug) e **corrija o formato** em `terraform.tfvars`/`locals.tf` — **jamais alargue o escopo para `*` "para destravar"** (ADR Seção 13.1 passo 5).

## Rollback (ADR Seção 12)

1. **Falha no apply:** objetos IAM idempotentes e sem dependentes; reaplicar o código anterior resolve.
2. **CI não autentica após o apply:** o caminho manual continua disponível (skill `docker-ecr-push` com o perfil local). Nenhuma aplicação fica indisponível — só o pipeline.
3. **Revogação de emergência:** remover `aws_iam_role_policy_attachment.ecr` e aplicar (efeito imediato para novas sessões; as já emitidas expiram em até 1 h). Alternativa drástica: deletar o OIDC provider — invalida **todas** as assunções via GitHub na conta.
4. **Destruição completa** (exige confirmação explícita do operador em sessão):

   ```bash
   .claude/skills/terraform-destroy/destroy.sh --allow-remote-apply 04-github-oidc-stack-ai            # só o plano
   .claude/skills/terraform-destroy/destroy.sh --allow-remote-apply --auto-approve 04-github-oidc-stack-ai
   ```

5. **Ponto de não retorno:** nenhum. Nada é criado/destruído em termos de dados por esta stack.

## Pontos de atenção

- **OIDC provider é único por conta.** Se `token.actions.githubusercontent.com` já existir (por exemplo criado por outra ferramenta), o apply falha com `EntityAlreadyExists` — importe, não recrie. Destruir esta stack **remove o provider da conta inteira**, quebrando qualquer outra role federada que dependa dele.
- **Renomear a role** (`project_name`, `aws_region` ou `environment`) força **replace** do `aws_iam_role` e invalida a repository variable `AWS_ROLE_ARN` no GitHub — o CI para de autenticar até a variable ser atualizada.
- **Acoplamento com `03-`:** os repositórios são resolvidos pelo **nome** via data source. Renomear um repositório em `03-` quebra o `plan` desta stack de forma barulhenta (comportamento desejado).
- **`ecr:GetAuthorizationToken` com `Resource: "*"`** é limitação do serviço, documentada pela AWS — não é folga de escopo.
- **Sem trilha CloudTrail dedicada** no repositório: o rastro de `AssumeRoleWithWebIdentity` vive no Event history da conta (90 dias). Registrado como risco aceito (ADR Seções 8 e 11).
- **Revogar access keys estáticas** usadas no push manual só **depois** da primeira publicação bem-sucedida pelo CI (ADR Seção 13.1 passo 6) — ação destrutiva, exige confirmação explícita do operador.
