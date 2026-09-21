############################################################################
# outputs.tf
#
# ADR-0004 (Secao 13.1 passo 1 / 13.3): outputs consumidos pela futura
# stack de workloads (04-workloads-stack-ai, ADR ainda nao emitido) e
# usados na validacao pos-deploy (Secao 13.4).
#
# Nomes no padrao {name}_{type}_{attribute} (regra
# .claude/rules/terraform-naming-conventions.md, Secao 5).
############################################################################

output "ecr_repository_frontend_name" {
  description = "Nome path-style do repositorio ECR do frontend (dvn-workshop/production/frontend)."
  value       = aws_ecr_repository.frontend.name
}

output "ecr_repository_frontend_url" {
  description = "URL do repositorio ECR do frontend ({account_id}.dkr.ecr.{region}.amazonaws.com/{name}), base para `docker push`/`pull` e para o campo `image:` de manifestos futuros."
  value       = aws_ecr_repository.frontend.repository_url
}

output "ecr_repository_frontend_arn" {
  description = "ARN do repositorio ECR do frontend."
  value       = aws_ecr_repository.frontend.arn
}

output "ecr_repository_backend_name" {
  description = "Nome path-style do repositorio ECR do backend (dvn-workshop/production/backend)."
  value       = aws_ecr_repository.backend.name
}

output "ecr_repository_backend_url" {
  description = "URL do repositorio ECR do backend ({account_id}.dkr.ecr.{region}.amazonaws.com/{name}), base para `docker push`/`pull` e para o campo `image:` de manifestos futuros."
  value       = aws_ecr_repository.backend.repository_url
}

output "ecr_repository_backend_arn" {
  description = "ARN do repositorio ECR do backend."
  value       = aws_ecr_repository.backend.arn
}

output "ecr_registry_id" {
  description = "ID do registry ECR (account ID) onde os repositorios foram criados — usado em `aws ecr get-login-password | docker login {registry_id}.dkr.ecr.{region}.amazonaws.com`."
  value       = aws_ecr_repository.frontend.registry_id
}
