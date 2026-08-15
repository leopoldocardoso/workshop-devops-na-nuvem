############################################################################
# providers.tf
#
# ADR-0001 (Secao 13.1 passo 5 / Secao 9): provider AWS com regiao
# parametrizada via var.aws_region e default_tags aplicando as tags
# obrigatorias (local.common_tags, definidas em locals.tf) em todos os
# recursos que suportam default_tags.
############################################################################

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}
