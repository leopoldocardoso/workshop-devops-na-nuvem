############################################################################
# main.tf
#
# Ponto de entrada da stack 04-github-oidc-stack-ai (ADR-0005, Revisao 1).
#
# Esta stack nao usa blocos `module` (ADR-0005 Secao 6.3 — nenhum modulo de
# terceiros; o submodulo comunitario terraform-aws-modules/iam//modules/
# iam-github-oidc-* foi explicitamente descartado para manter a trust
# policy auditavel linha a linha). Este arquivo nao declara recursos;
# serve como indice de onde cada dominio esta implementado:
#
#   versions.tf       -> Terraform CLI + provider hashicorp/aws pinado.
#   backend.tf        -> backend S3 (configuracao parcial; backend.hcl).
#   providers.tf      -> provider "aws" com default_tags.
#   variables.tf      -> variaveis de input (sem default; valores em
#                        terraform.tfvars).
#   locals.tf         -> ambiente fixo "prd", nomes de negocio, os dois
#                        formatos do claim `sub` e as tags comuns.
#   data.tf           -> data.aws_caller_identity.current e os dois
#                        data.aws_ecr_repository de 03-ecr-stack-ai.
#   oidc.tf           -> aws_iam_openid_connect_provider.this
#                        (token.actions.githubusercontent.com).
#   iam.ecr-role.tf   -> trust policy + aws_iam_role.ecr +
#                        aws_iam_policy.ecr + attachment.
#   outputs.tf        -> ARNs do provider OIDC e da role (esta ultima e o
#                        valor da repository variable AWS_ROLE_ARN
#                        consumida pelos workflows do ADR-0007).
#
# Escopo estrito (ADR-0005 Secoes 13 e 14): APENAS a fundacao de identidade
# (OIDC provider + 1 IAM Role + 1 IAM Policy de ECR + attachment). Nenhum
# workflow do GitHub Actions (ADR-0007), nenhum ArgoCD (ADR-0006), nenhuma
# permissao de terraform/EKS/S3 para CI, e NENHUMA alteracao em
# 00-/01-/02-/03-.
