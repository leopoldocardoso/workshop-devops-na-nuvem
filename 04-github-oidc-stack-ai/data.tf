############################################################################
# data.tf
#
# ADR-0005 (Secao 6.2 / 13.1 passo 2): leituras da conta e dos repositorios
# ECR criados por 03-ecr-stack-ai (ADR-0004). SOMENTE LEITURA — esta stack
# nao cria nem altera uma linha de 03-.
#
# Acoplamento conhecido: os repositorios sao resolvidos pelo NOME (input em
# terraform.tfvars), nao por terraform_remote_state — mesmo principio de
# desacoplamento entre stacks ja usado por 02- e 05-. Se 03- ainda nao
# estiver aplicado, o `plan` desta stack falha de forma barulhenta na
# leitura do data source (ADR-0005 Secao 13.1 passo 0, pre-checagem
# bloqueante).
############################################################################

# Account ID da conta corrente — usado para montar o ARN do OIDC provider
# no Principal "Federated" da trust policy, evitando hardcode da conta
# (ADR-0005 Premissa 7).
data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "frontend" {
  name = var.ecr.frontend_repository_name
}

data "aws_ecr_repository" "backend" {
  name = var.ecr.backend_repository_name
}
