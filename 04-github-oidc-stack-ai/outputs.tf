############################################################################
# outputs.tf
#
# ADR-0005 (criterio de aceitacao 13.3): expor `github_oidc_provider_arn` e
# `github_oidc_ecr_role_arn`, ambos com `description`.
#
# `github_oidc_ecr_role_arn` e o valor que o OPERADOR deve configurar como
# repository variable `AWS_ROLE_ARN` no GitHub (Settings > Secrets and
# variables > Actions > Variables), consumida pelos workflows do ADR-0007
# via ${{ vars.AWS_ROLE_ARN }}. Um ARN nao autentica nada por si — pode ser
# variable publica, nunca precisa ser secret (ADR-0005 Secao 8).
#
# NENHUM output sensivel: o repositorio esta PUBLICO durante o laboratorio e
# o driver terraform-deploy despeja `terraform output -json` em
# docs/deployments/04-github-oidc-stack-ai.md.
#
# Nomes no padrao {name}_{type}_{attribute} (regra
# .claude/rules/terraform-naming-conventions.md, Secao 5).
############################################################################

output "github_oidc_provider_arn" {
  description = "ARN do IAM OIDC identity provider do GitHub Actions (token.actions.githubusercontent.com). Unico por conta — reutilizavel por futuras roles de CI."
  value       = aws_iam_openid_connect_provider.this.arn
}

output "github_oidc_ecr_role_arn" {
  description = "ARN da IAM Role de CI assumida pelo GitHub Actions para push/pull no ECR. Configurar como repository variable AWS_ROLE_ARN, consumida como vars.AWS_ROLE_ARN nos workflows do ADR-0007."
  value       = aws_iam_role.ecr.arn
}

output "github_oidc_ecr_role_name" {
  description = "Nome da IAM Role de CI (prd-github-oidc-ecr-role-us-east-1), util para consultas de CloudTrail e para `aws iam get-role`."
  value       = aws_iam_role.ecr.name
}

output "github_oidc_ecr_policy_arn" {
  description = "ARN da customer managed policy de ECR anexada a role de CI — ponto unico a auditar/remover em uma revogacao de emergencia (ADR-0005 Secao 12, item 3)."
  value       = aws_iam_policy.ecr.arn
}

output "aws_account_id" {
  description = "Account ID da conta onde a stack foi aplicada, usado para conferir o ARN retornado por `aws sts get-caller-identity` no teste de identidade (ADR-0005 Secao 13.4, Teste 1)."
  value       = data.aws_caller_identity.current.account_id
}
