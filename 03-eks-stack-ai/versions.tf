############################################################################
# versions.tf
#
# ADR-0003 (Secao 6.3 / 13.1 passo 1): Terraform CLI e provider
# hashicorp/aws, mesmo floor/constraint ja adotado em 00-/01- para
# consistencia de ferramental entre stacks do repositorio.
#
# hashicorp/aws ~> 6.0, testado com 6.62.0 (validado via terraform-mcp
# get_latest_provider_version / get_provider_details em 2026-08-28 — mesma
# versao referenciada no ADR-0003 Secao 6.3).
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
