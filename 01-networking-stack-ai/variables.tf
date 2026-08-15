############################################################################
# variables.tf
#
# ADR-0001 (Secao 13.1 passo 6 / Secao 13.2): variaveis de input da stack.
# Nenhum valor sensivel deve ser colocado em terraform.tfvars versionado
# (Secao 8 do ADR-0001) — todas as variaveis abaixo sao valores publicos por
# natureza (regiao, CIDR, flags booleanas, tags).
#
# Estrutura em conformidade com .claude/rules/terraform-naming-conventions.md
# (Secao 4): variaveis do mesmo dominio agrupadas em object(...); variaveis
# verdadeiramente independentes (aws_region, project_name, tags) permanecem
# standalone. Nenhuma variavel declara `default` — os valores efetivos ficam
# em terraform.tfvars, na raiz da stack (ver terraform.tfvars.example).
#
# Revisao 5 do ADR-0001 (Secao 4, decisao D2 / Secao 13.1 passo 3): a
# variavel "environment" foi removida — a stack passa a suportar um unico
# ambiente ("prd"), fixado como local.environment em locals.tf.
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
# Dominio "vpc": CIDR fixo (requisito de negocio, ADR-0001 Secao 6.2) e
# AZs a utilizar. As sub-redes NAO sao um input desta variavel: elas sao
# calculadas dinamicamente em locals.tf via cidrsubnet(), conforme decisao
# do ADR-0001 (Secao 13.1 passo 8) — preservado sem alteracao neste refactor.
# ----------------------------------------------------------------------
variable "vpc" {
  description = "Configuracao agregada da VPC: CIDR fixo da stack e AZs a utilizar (se a lista de AZs vier vazia, a stack resolve dinamicamente as 2 primeiras AZs disponiveis na regiao via data \"aws_availability_zones\", conforme locals.tf)."
  type = object({
    cidr               = string
    availability_zones = list(string)
  })
  nullable = false

  validation {
    condition     = can(cidrhost(var.vpc.cidr, 0)) && can(regex("/24$", var.vpc.cidr))
    error_message = "O valor de 'vpc.cidr' deve ser um bloco CIDR IPv4 valido com prefixo /24 (ex.: 192.168.1.0/24)."
  }
}

# ----------------------------------------------------------------------
# Dominio "nat_gateway": estrategia de egress das sub-redes privadas
# (ADR-0001 Secao 6.2/13.2). 'single_nat_gateway' e mantida como atributo
# dedicado por exigencia de paridade semantica/documentacional com a
# Secao 13.2 do ADR, ainda que a multiplicidade efetiva de recursos seja
# determinada por 'one_nat_gateway_per_az' (ver locals.tf).
# ----------------------------------------------------------------------
variable "nat_gateway" {
  description = "Estrategia de NAT Gateway para egress das sub-redes privadas: 'enabled' habilita a criacao de aws_nat_gateway/aws_eip; 'single_nat_gateway' sinaliza a intencao de NAT unico compartilhado — configuracao fixa e definitiva do unico ambiente desta stack (prd) a partir da Revisao 5 do ADR-0001 (Premissa 14); 'one_nat_gateway_per_az' habilita HA completa com 1 NAT Gateway por AZ e permanece funcional no codigo apenas como caminho de reversao futura (ADR-0001 Secao 11/12), nao utilizado nesta revisao."
  type = object({
    enabled                = bool
    single_nat_gateway     = bool
    one_nat_gateway_per_az = bool
  })
  nullable = false
}

# ----------------------------------------------------------------------
# Dominio "flow_logs": VPC Flow Logs com destino CloudWatch Logs
# (ADR-0001 Secao 6.2/8/13.2).
# ----------------------------------------------------------------------
variable "flow_logs" {
  description = "Configuracao de VPC Flow Logs: 'enabled' habilita a criacao de aws_flow_log, aws_cloudwatch_log_group, aws_iam_role e aws_iam_role_policy; 'retention_days' e a retencao do log group."
  type = object({
    enabled        = bool
    retention_days = number
  })
  nullable = false
}

variable "tags" {
  description = "Tags adicionais alem das obrigatorias definidas em locals.tf (ADR-0001 Secao 9). Tambem pode ser usada para sobrescrever os placeholders de 'Owner' e 'CostCenter' definidos em locals.tf, que ainda nao possuem valor definitivo no ADR (ver README.md / Pontos de Atencao)."
  type        = map(string)
  nullable    = false
}
