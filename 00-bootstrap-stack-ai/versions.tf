############################################################################
# versions.tf
#
# ADR-0002 (Secao 6.3 / 13.1 passo 1): mesmo floor de Terraform CLI e mesma
# constraint de provider ja adotados em 01-networking-stack-ai, para
# consistencia de ferramental entre stacks do repositorio. Nenhum recurso
# desta stack exige especificamente `use_lockfile` (backend e local
# permanente — ADR-0002 Secao 4, decisao D3), mas o floor e mantido igual
# por consistencia, nao por necessidade tecnica desta stack especifica.
#
# hashicorp/aws ~> 6.0 validado via terraform-mcp get_latest_provider_version
# (ultima versao estavel: 6.60.0, compatível com a constraint).
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
