############################################################################
# main.tf
#
# Ponto de entrada da stack 03-ecr-stack-ai (ADR-0004).
#
# Esta stack nao usa blocos `module` (ADR-0004 Secao 6.3) — todos os
# recursos sao nativos do provider hashicorp/aws, organizados em arquivos
# por dominio (regra .claude/rules/terraform-naming-conventions.md, Secao 2).
# Este arquivo nao declara recursos; serve apenas como indice de onde cada
# dominio esta implementado:
#
#   versions.tf                 -> Terraform CLI + provider hashicorp/aws.
#   backend.tf                  -> backend S3 (configuracao parcial).
#   providers.tf                -> provider "aws" + default_tags.
#   variables.tf                -> variaveis de input (sem default).
#   locals.tf                   -> ambiente fixo "prd", nomes dos
#                                   repositorios, tags comuns.
#   ecr.tf                      -> aws_ecr_repository.frontend / .backend.
#   ecr.lifecycle-policy.tf     -> aws_ecr_lifecycle_policy.frontend /
#                                   .backend (retencao de imagens).
#   outputs.tf                  -> URLs/ARNs dos repositorios, consumidos
#                                   pela futura stack de workloads.
#
# Escopo estrito (ADR-0004 Secao 13 / 14): apenas os 2 repositorios ECR e
# suas lifecycle policies. Nenhum docker build/push, nenhum manifesto
# Kubernetes, nenhuma alteracao em 00-/01-/02- e nenhuma IAM Role/policy
# nova — o pull pelos worker nodes reaproveita a policy gerenciada
# AmazonEC2ContainerRegistryReadOnly ja anexada em 02-eks-stack-ai.
############################################################################
