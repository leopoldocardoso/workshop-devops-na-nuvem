############################################################################
# providers.tf
#
# ADR-0005 (Secao 9 / 13.1 passo 1): provider AWS com regiao parametrizada
# via var.aws_region e default_tags aplicando as tags obrigatorias
# (local.common_tags, definidas em locals.tf).
#
# Observacao: IAM e um servico GLOBAL — os recursos desta stack nao sao
# regionais. var.aws_region define o endpoint usado pelas chamadas e a
# regiao dos data sources de ECR (que SAO regionais, us-east-1), alem de
# compor o sufixo dos nomes de negocio (local.name_prefix / name_suffix).
############################################################################

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}
