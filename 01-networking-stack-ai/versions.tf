############################################################################
# versions.tf
#
# ADR-0001 (Secao 5 / 6.3 / 13.1 passo 3): Terraform CLI, no minimo, na
# versao necessaria para habilitar locking nativo do backend S3 via
# `use_lockfile = true` (disponivel a partir da 1.10.0, ver backend.tf); e
# provider hashicorp/aws ~> 6.0 (testado com 6.55.0, validado via
# terraform-mcp `get_latest_provider_version`).
#
# Floor de required_version atualizado em 2026-07-19 para >= 1.15.8 (ultima
# versao estavel do Terraform CLI no momento, confirmada via GitHub Releases
# de hashicorp/terraform — o MCP `terraform` nao expoe uma ferramenta de
# "latest core version", apenas get_latest_provider_version/
# get_latest_module_version). O provider hashicorp/aws ja estava na ultima
# versao estavel (6.55.0, confirmado via terraform-mcp get_latest_provider_
# version) — nenhuma mudanca necessaria no pin do provider.
#
# ATENCAO (fora do escopo original do ADR-0001, que especificava apenas
# >= 1.10.0): elevar o floor para >= 1.15.8 exige que toda execucao de
# `init`/`plan`/`apply` desta stack (local ou CI) use Terraform CLI
# >= 1.15.8. Isso NAO altera nenhum recurso AWS, CIDR ou comportamento de
# infraestrutura — e uma restricao de ferramental. Recomenda-se registrar
# esse ajuste como uma revisao/errata do ADR-0001 caso deva persistir.
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
