############################################################################
# variables.tf
#
# ADR-0002 (Secao 13.2): variaveis de input da stack. Estrutura em
# conformidade com .claude/rules/terraform-naming-conventions.md (Secao 4):
# variaveis do mesmo dominio agrupadas em object(...); variaveis
# verdadeiramente independentes (aws_region, project_name, tags) permanecem
# standalone. Nenhuma variavel declara `default` — os valores efetivos ficam
# em terraform.tfvars, na raiz da stack (ver terraform.tfvars.example).
#
# Sem `variable "environment"` — mesmo padrao da Revisao 5 do ADR-0001:
# local.environment = "prd" fixo em locals.tf (ADR-0002 Premissa 1).
############################################################################

variable "aws_region" {
  description = "Regiao AWS onde a stack e aplicada."
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "Nome logico do projeto, usado na naming convention {env}-{project_name}-{service}-{region} e na tag 'Project'."
  type        = string
  nullable    = false
}

# ----------------------------------------------------------------------
# Dominio "state_bucket": parametros do bucket S3 de backend remoto
# (ADR-0002 Secao 6.2/13.2). O nome do bucket NAO e um input desta
# variavel: e calculado dinamicamente em locals.tf (Secao 4, decisao D2).
# ----------------------------------------------------------------------
variable "state_bucket" {
  description = "Configuracao agregada do bucket S3 de state: 'force_destroy' deve permanecer 'false' (ADR-0002 Secao 11 — previne destruicao acidental do bucket enquanto contiver objetos); 'noncurrent_version_expiration_days' e o numero de dias apos os quais versoes nao-atuais do objeto sao expiradas; 'noncurrent_version_retain_count' e o numero minimo de versoes nao-atuais recentes retidas independentemente da idade; 'abort_incomplete_multipart_upload_days' e o numero de dias apos os quais uploads multipart incompletos sao abortados."
  type = object({
    force_destroy                          = bool
    noncurrent_version_expiration_days     = number
    noncurrent_version_retain_count        = number
    abort_incomplete_multipart_upload_days = number
  })
  nullable = false

  validation {
    condition     = var.state_bucket.force_destroy == false
    error_message = "state_bucket.force_destroy deve ser 'false' (ADR-0002 Secao 11): este bucket guarda o .tfstate de todas as stacks consumidoras e nao deve permitir destruicao enquanto contiver objetos."
  }
}

variable "tags" {
  description = "Tags adicionais alem das obrigatorias definidas em locals.tf (ADR-0002 Secao 9). Tambem pode ser usada para sobrescrever os placeholders de 'Owner' e 'CostCenter' definidos em locals.tf, que ainda nao possuem valor definitivo no ADR (ver README.md / Pontos de Atencao)."
  type        = map(string)
  nullable    = false
}
