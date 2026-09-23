############################################################################
# versions.tf
#
# ADR-0005 (Secao 6.3 / 13.1 passo 1): mesmo floor de Terraform CLI
# (>= 1.15.8) adotado em 00-/01-/02-/03-/05- e constraint de provider
# fixada em hashicorp/aws ~> 6.0.
#
# Ultima versao publicada validada via terraform-mcp
# `get_latest_provider_version` em 2026-09-22: 6.66.0 — mesma versao contra
# a qual os argumentos de aws_iam_openid_connect_provider (inclusive o
# carater OPCIONAL de `thumbprint_list`, ADR-0005 Premissa 5) e de
# data.aws_ecr_repository foram conferidos via `get_provider_details`.
############################################################################

terraform {
  required_version = ">= 1.15.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
