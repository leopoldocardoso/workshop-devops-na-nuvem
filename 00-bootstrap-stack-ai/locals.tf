############################################################################
# locals.tf
#
# ADR-0002 (Secao 13.1 passo 1 / Secao 9): ambiente fixo, naming do bucket
# (Secao 4, decisao D2) e tags comuns obrigatorias.
#
# Mesmo padrao de 01-networking-stack-ai (Revisao 5 do ADR-0001): sem
# `variable "environment"` — o ambiente unico do projeto ("prd") e fixado
# aqui como local, nao como input livre (ADR-0002 Premissa 1).
############################################################################

locals {
  # Ambiente unico e definitivo do projeto (ADR-0002 Premissa 1, herdada da
  # Revisao 5 do ADR-0001). Nao e um input Terraform.
  environment = "prd"

  # Prefixo de naming convention: {env}-{project_name}
  # (ADR-0002 Secao 9: "{env}-{project_name}-{service}-{region}")
  name = "${local.environment}-${var.project_name}"

  # --------------------------------------------------------------------
  # Nome do bucket S3 de state (ADR-0002 Secao 4, decisao D2 / Secao 9).
  #
  # Extensao especifica desta stack a naming convention-base do projeto:
  # como nomes de bucket S3 precisam ser globalmente unicos (nao apenas
  # unicos dentro da conta/regiao), o padrao "{env}-{project_name}-{service}
  # -{region}" e estendido com o segmento "{account_id}", resolvido
  # dinamicamente via data.aws_caller_identity (Secao 6.2) em vez de um
  # sufixo aleatorio (evita dependencia do provider hashicorp/random):
  #
  #   {env}-{project_name}-{service}-{account_id}-{region}
  #   -> prd-bootstrap-tfstate-{account_id}-sa-east-1
  # --------------------------------------------------------------------
  bucket_name = "${local.name}-tfstate-${data.aws_caller_identity.current.account_id}-${var.aws_region}"

  # --------------------------------------------------------------------
  # Tags obrigatorias (ADR-0002, Secao 9). Aplicadas via default_tags do
  # provider (providers.tf) E reforcadas individualmente em cada recurso
  # nativo que suporta `tags`, mesmo padrao de 01-networking-stack-ai.
  #
  # ATENCAO: 'Owner' e 'CostCenter' nao possuem valor definitivo no ADR-0002
  # ("a definir pelo solicitante" — Secao 9, Premissa 13). Os placeholders
  # abaixo DEVEM ser sobrescritos via var.tags (terraform.tfvars, na raiz da
  # stack) antes do apply. Ver README.md > Pontos de Atencao.
  #
  # DataClassification = "confidential" (diferente de "internal" em 01-):
  # este bucket armazena .tfstate, que pode conter dados sensiveis de
  # infraestrutura de todas as stacks do repositorio (ADR-0002 Secao 9).
  # --------------------------------------------------------------------
  common_tags = merge(
    {
      Environment        = local.environment
      Owner              = "unassigned"
      CostCenter         = "unassigned"
      Project            = var.project_name
      ManagedBy          = "terraform"
      DataClassification = "confidential"
      StackName          = "00-bootstrap-stack-ai"
    },
    var.tags
  )
}
