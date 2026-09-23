############################################################################
# versions.tf
#
# ADR-0006 (Secao 6.3 / 13.1 passo 3): mesmo floor de Terraform CLI
# (>= 1.15.8) adotado em 00-/01-/02-/03- e constraints de provider
# fixadas:
#
#   hashicorp/aws  ~> 6.0  (ultima publicada validada via terraform-mcp
#                           `get_latest_provider_version`: 6.66.0 em
#                           2026-09-22) — data sources do cluster EKS.
#   hashicorp/helm ~> 3.0  (ultima publicada validada via terraform-mcp:
#                           3.3.0 em 2026-09-22) — helm_release.
#
# ATENCAO (ADR-0006 Premissa 5): no provider helm v3 a configuracao de
# cluster e um ATRIBUTO (`kubernetes = { ... }`), nao um bloco. Sintaxe
# confirmada na doc do provider 3.3.0 via terraform-mcp
# `get_provider_details` em 2026-09-22 — ver providers.tf.
############################################################################

terraform {
  required_version = ">= 1.15.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}
