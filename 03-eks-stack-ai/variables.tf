############################################################################
# variables.tf
#
# ADR-0003 (Secao 13.1 passo 1 / Secao 13.2): variaveis de input da stack.
#
# Estrutura em conformidade com .claude/rules/terraform-naming-conventions.md
# (Secao 4): variaveis do mesmo dominio agrupadas em object(...); variaveis
# verdadeiramente independentes (aws_region, project_name, tags) permanecem
# standalone. Nenhuma variavel declara `default` — os valores efetivos ficam
# em terraform.tfvars, na raiz da stack (ver terraform.tfvars.example).
#
# Sem `variable "environment"` — mesmo padrao de 00-/01-: local.environment
# fixo em "prd" (locals.tf).
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
# Dominio "networking": valores usados para filtrar os data sources de
# VPC/sub-redes de 01-networking-stack-ai via tags (ADR-0003 Secao 4,
# decisao D4) — esta stack NAO usa terraform_remote_state.
# ----------------------------------------------------------------------
variable "networking" {
  description = "Filtros de tag usados para localizar, via data sources nativos (aws_vpc/aws_subnets), a VPC e as sub-redes ja provisionadas por 01-networking-stack-ai (ADR-0003 Secao 4, decisao D4). 'stack_name' deve corresponder a tag 'StackName' e 'environment' a tag 'Environment' aplicadas em todos os recursos daquela stack."
  type = object({
    stack_name  = string
    environment = string
  })
  nullable = false
}

# ----------------------------------------------------------------------
# Dominio "eks_cluster": versao do Kubernetes, acesso ao endpoint da API e
# control plane logging (ADR-0003 Secao 4, decisoes D1/D2; Secao 6.2).
# ----------------------------------------------------------------------
variable "eks_cluster" {
  description = "Configuracao agregada do control plane EKS: versao do Kubernetes, CIDRs autorizados a acessar o endpoint publico da API (obrigatorio, sem default, nunca 0.0.0.0/0 — ADR-0003 Secao 4/D2), tipos de log do control plane a habilitar e retencao do CloudWatch Log Group."
  type = object({
    kubernetes_version           = string
    endpoint_public_access_cidrs = list(string)
    enabled_log_types            = list(string)
    log_retention_days           = number
  })
  nullable = false

  validation {
    condition     = length(var.eks_cluster.endpoint_public_access_cidrs) > 0
    error_message = "eks_cluster.endpoint_public_access_cidrs e obrigatorio e nao pode ser uma lista vazia — informe o(s) CIDR(s) reais de onde o endpoint publico da API sera acessado (ADR-0003 Secao 4/D2)."
  }

  validation {
    condition     = !contains(var.eks_cluster.endpoint_public_access_cidrs, "0.0.0.0/0")
    error_message = "eks_cluster.endpoint_public_access_cidrs nao pode conter '0.0.0.0/0' — o endpoint publico da API deve ser restrito a CIDR(s) especificos (ADR-0003 Secao 4/D2, Secao 8)."
  }

  validation {
    condition     = alltrue([for cidr in var.eks_cluster.endpoint_public_access_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Todos os itens de eks_cluster.endpoint_public_access_cidrs devem ser blocos CIDR IPv4 validos."
  }
}

# ----------------------------------------------------------------------
# Dominio "eks_secrets_encryption": CMK dedicada para envelope encryption
# de Secrets do Kubernetes (ADR-0003 Secao 4, decisao D3).
# ----------------------------------------------------------------------
variable "eks_secrets_encryption" {
  description = "Configuracao da CMK dedicada usada em encryption_config do cluster para envelope encryption de Secrets do Kubernetes (ADR-0003 Secao 4/D3)."
  type = object({
    kms_deletion_window_days = number
  })
  nullable = false

  validation {
    condition     = var.eks_secrets_encryption.kms_deletion_window_days >= 7 && var.eks_secrets_encryption.kms_deletion_window_days <= 30
    error_message = "eks_secrets_encryption.kms_deletion_window_days deve estar entre 7 e 30 (limites do argumento deletion_window_in_days de aws_kms_key)."
  }
}

# ----------------------------------------------------------------------
# Dominio "eks_node_group": Managed Node Group EC2 ON_DEMAND (requisito
# explicito do solicitante — ADR-0003 Secao 2/6.2).
# ----------------------------------------------------------------------
variable "eks_node_group" {
  description = "Configuracao agregada do EKS Managed Node Group: tipos de instancia, capacity_type, AMI, tamanho de disco e parametros de scaling/update (ADR-0003 Secao 6.2/13.2)."
  type = object({
    instance_types  = list(string)
    capacity_type   = string
    ami_type        = string
    disk_size       = number
    desired_size    = number
    min_size        = number
    max_size        = number
    max_unavailable = number
  })
  nullable = false

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.eks_node_group.capacity_type)
    error_message = "eks_node_group.capacity_type deve ser 'ON_DEMAND' ou 'SPOT' (ADR-0003 Secao 2: requisito explicito 'ON_DEMAND')."
  }

  validation {
    condition     = var.eks_node_group.min_size <= var.eks_node_group.desired_size && var.eks_node_group.desired_size <= var.eks_node_group.max_size
    error_message = "eks_node_group deve respeitar min_size <= desired_size <= max_size."
  }
}

variable "tags" {
  description = "Tags adicionais alem das obrigatorias definidas em locals.tf (ADR-0003 Secao 9). Tambem pode ser usada para sobrescrever os placeholders de 'Owner' e 'CostCenter' definidos em locals.tf, que ainda nao possuem valor definitivo no ADR."
  type        = map(string)
  nullable    = false
}
