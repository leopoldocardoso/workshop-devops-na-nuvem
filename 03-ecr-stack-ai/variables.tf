############################################################################
# variables.tf
#
# ADR-0004 (Secao 13.1 passo 1 / Secao 13.2): variaveis de input da stack.
#
# Estrutura em conformidade com .claude/rules/terraform-naming-conventions.md
# (Secao 4): variaveis do mesmo dominio agrupadas em object(...) (`ecr`,
# `ecr_lifecycle`); variaveis verdadeiramente independentes (aws_region,
# project_name, tags) permanecem standalone. Nenhuma variavel declara
# `default` — os valores efetivos ficam em terraform.tfvars, na raiz da
# stack (ver terraform.tfvars.example).
#
# Sem `variable "environment"` — mesmo padrao de 00-/01-/02-:
# local.environment fixo em "prd" (locals.tf).
############################################################################

variable "aws_region" {
  description = "Regiao AWS onde a stack e aplicada (ADR-0004: us-east-1)."
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "Nome logico do projeto, usado apenas na tag 'Project' e em identificadores internos (ADR-0004 Premissa 5: \"ecr\"). NAO compoe o `name` dos repositorios ECR (Secao 9)."
  type        = string
  nullable    = false
}

# ----------------------------------------------------------------------
# Dominio "ecr": configuracao comum aos dois repositorios (frontend e
# backend) — nome path-style, mutabilidade de tag, scanning e encriptacao
# (ADR-0004 Secao 4, decisoes D1/D2/D3; Secao 6.2; Secao 13.2).
# ----------------------------------------------------------------------
variable "ecr" {
  description = "Configuracao agregada dos repositorios ECR: `namespace` e `environment_segment` montam o nome path-style `{namespace}/{environment_segment}/{app}` pedido pelo solicitante (ADR-0004 Secao 9 — contrato externo, NAO segue {env}-{project}-{service}-{region}); `image_tag_mutability` + `image_tag_mutability_exclusion_filter` (D3: IMMUTABLE_WITH_EXCLUSION com excecao `latest*`); `scan_on_push` (scanning basico a cada push); `encryption_type` (D2: AES256, chave gerenciada pela AWS)."
  type = object({
    namespace                             = string
    environment_segment                   = string
    image_tag_mutability                  = string
    image_tag_mutability_exclusion_filter = string
    scan_on_push                          = bool
    encryption_type                       = string
  })
  nullable = false

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE", "IMMUTABLE_WITH_EXCLUSION", "MUTABLE_WITH_EXCLUSION"], var.ecr.image_tag_mutability)
    error_message = "ecr.image_tag_mutability deve ser um de: MUTABLE, IMMUTABLE, IMMUTABLE_WITH_EXCLUSION, MUTABLE_WITH_EXCLUSION (valores aceitos por aws_ecr_repository). ADR-0004 D3 prescreve IMMUTABLE_WITH_EXCLUSION."
  }

  validation {
    condition     = contains(["AES256", "KMS"], var.ecr.encryption_type)
    error_message = "ecr.encryption_type deve ser 'AES256' ou 'KMS'. ADR-0004 D2 prescreve AES256 (nenhuma CMK dedicada e criada por esta stack)."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*$", var.ecr.namespace)) && can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*$", var.ecr.environment_segment))
    error_message = "ecr.namespace e ecr.environment_segment devem conter apenas letras minusculas, numeros e separadores ._- (regras de nome de repositorio ECR); o separador '/' entre segmentos e adicionado pela stack."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9._*-]{1,128}$", var.ecr.image_tag_mutability_exclusion_filter)) && length(regexall("\\*", var.ecr.image_tag_mutability_exclusion_filter)) <= 2
    error_message = "ecr.image_tag_mutability_exclusion_filter deve conter apenas letras, numeros e ._*-, ate 128 caracteres e no maximo 2 wildcards (*) — restricoes do argumento image_tag_mutability_exclusion_filter.filter."
  }
}

# ----------------------------------------------------------------------
# Dominio "ecr_lifecycle": regras de retencao de imagens aplicadas
# identicamente aos dois repositorios (ADR-0004 Secao 4, decisao D4).
# ----------------------------------------------------------------------
variable "ecr_lifecycle" {
  description = "Regras da lifecycle policy (ADR-0004 D4): `untagged_expire_days` = expira imagens NAO tageadas com mais de N dias desde o push; `tagged_keep_count` = mantem apenas as N imagens tageadas mais recentes, expirando o excedente. Ajustavel sem recriar os repositorios (Secao 11)."
  type = object({
    untagged_expire_days = number
    tagged_keep_count    = number
  })
  nullable = false

  validation {
    condition     = var.ecr_lifecycle.untagged_expire_days >= 1 && floor(var.ecr_lifecycle.untagged_expire_days) == var.ecr_lifecycle.untagged_expire_days
    error_message = "ecr_lifecycle.untagged_expire_days deve ser um inteiro >= 1 (countNumber de sinceImagePushed, em dias)."
  }

  validation {
    condition     = var.ecr_lifecycle.tagged_keep_count >= 1 && floor(var.ecr_lifecycle.tagged_keep_count) == var.ecr_lifecycle.tagged_keep_count
    error_message = "ecr_lifecycle.tagged_keep_count deve ser um inteiro >= 1 (countNumber de imageCountMoreThan)."
  }
}

variable "tags" {
  description = "Tags adicionais alem das obrigatorias definidas em locals.tf (ADR-0004 Secao 9). Tambem usada para sobrescrever os placeholders de 'Owner' e 'CostCenter' definidos em locals.tf, que ainda nao possuem valor definitivo no ADR."
  type        = map(string)
  nullable    = false
}
