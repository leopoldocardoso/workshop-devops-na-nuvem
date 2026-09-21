############################################################################
# versions.tf
#
# ADR-0004 (Secao 6.3 / 13.1 passo 1): mesmo floor de Terraform CLI
# (>= 1.15.8) e mesma constraint de provider (hashicorp/aws ~> 6.0) ja
# adotados em 00-/01-/02-. Argumentos de aws_ecr_repository
# (image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION",
# image_tag_mutability_exclusion_filter) e aws_ecr_lifecycle_policy
# validados via terraform-mcp `get_provider_details` contra a versao
# 6.66.0 do provider em 2026-09-21.
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
