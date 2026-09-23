############################################################################
# variables.tf
#
# ADR-0006 (Secao 13.2): variaveis de input da stack.
#
# Estrutura em conformidade com .claude/rules/terraform-naming-conventions.md
# (Secao 4): variaveis do mesmo dominio agrupadas em object(...) (`eks`,
# `argocd`, `argocd_application`); variaveis verdadeiramente independentes
# (aws_region, project_name, tags) permanecem standalone. Nenhuma variavel
# declara `default` — os valores efetivos ficam em terraform.tfvars, na raiz
# da stack (ver terraform.tfvars.example).
#
# Sem `variable "environment"` — mesmo padrao de 00-/01-/02-/03-:
# local.environment fixo em "prd" (locals.tf).
#
# NENHUMA variavel recebe credencial: esta stack nao manipula segredo algum
# (ADR-0006 D6/Opcao D — repositorio publico, clone anonimo por HTTPS).
############################################################################

variable "aws_region" {
  description = "Regiao AWS onde a stack e aplicada e onde vive o cluster EKS alvo (ADR-0006: us-east-1)."
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "Nome logico do projeto, usado apenas na tag 'Project' (ADR-0006 Premissa 14: \"argocd\")."
  type        = string
  nullable    = false
}

# ----------------------------------------------------------------------
# Dominio "eks": identificacao do cluster alvo, consumido por data source
# (ADR-0006 Secao 6.2). Esta stack NAO cria nem altera o cluster.
# ----------------------------------------------------------------------
variable "eks" {
  description = "Cluster EKS alvo (criado por 02-eks-stack-ai, ADR-0003). Consumido apenas por data source para autenticar o provider helm no endpoint publico restrito da API (ADR-0006 Premissas 1 e 6)."
  type = object({
    cluster_name = string
  })
  nullable = false

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9_-]{0,99}$", var.eks.cluster_name))
    error_message = "eks.cluster_name deve ser um nome valido de cluster EKS (letras, numeros, '-' e '_', ate 100 caracteres)."
  }
}

# ----------------------------------------------------------------------
# Dominio "argocd": instalacao do chart argo-cd (ADR-0006 D1/A, D3/A, D4/A).
# ----------------------------------------------------------------------
variable "argocd" {
  description = "Configuracao agregada do release do ArgoCD: `namespace` (criado pelo proprio release), `chart_version` (FIXADA — nunca a ultima implicita), `server_service_type` (D4/A: ClusterIP; LoadBalancer e Non-goal), `ha_enabled` (D3/A: false — o node group de 2x t3.medium nao comporta o modo HA), e os flags de componentes opcionais `dex_enabled`/`notifications_enabled`/`applicationset_enabled` (Premissa 13: todos false)."
  type = object({
    namespace              = string
    chart_version          = string
    server_service_type    = string
    ha_enabled             = bool
    dex_enabled            = bool
    notifications_enabled  = bool
    applicationset_enabled = bool
  })
  nullable = false

  validation {
    condition     = contains(["ClusterIP"], var.argocd.server_service_type)
    error_message = "argocd.server_service_type deve ser 'ClusterIP' (ADR-0006 D4/Opcao A). 'LoadBalancer' e Non-goal explicito (Secao 14) e ficaria <pending> por ausencia de AWS Load Balancer Controller; 'NodePort' foi avaliado e preterido (D4/Opcao B)."
  }

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.argocd.chart_version))
    error_message = "argocd.chart_version deve ser uma versao exata do chart (ex.: \"10.9.2\"), nunca um range — ADR-0006 Premissa 4 exige versao fixada."
  }

  validation {
    condition     = var.argocd.ha_enabled == false
    error_message = "argocd.ha_enabled deve ser false (ADR-0006 D3/Opcao A): o modo HA do chart nao cabe no node group de 2x t3.medium junto dos pods de aplicacao."
  }

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.argocd.namespace))
    error_message = "argocd.namespace deve ser um nome de namespace Kubernetes valido (RFC 1123)."
  }
}

# ----------------------------------------------------------------------
# Dominio "argocd_application": a unica Application do ArgoCD, renderizada
# via `extraObjects` do proprio release (ADR-0006 D2/Opcao C).
# ----------------------------------------------------------------------
variable "argocd_application" {
  description = "Configuracao da Application GitOps (ADR-0006 Secao 5 / D2/C). `repo_url` e HTTPS PUBLICO e SEM CREDENCIAL (D6/Opcao D) — nenhum Secret de repositorio e criado. `enabled` existe para a primeira sync controlada (Secao 13.1 passos 3 e 6): o primeiro apply instala o ArgoCD sem a Application; o segundo a cria com `automated_*` = false; o terceiro habilita `automated`."
  type = object({
    enabled               = bool
    name                  = string
    repo_url              = string
    path                  = string
    target_revision       = string
    destination_namespace = string
    automated_prune       = bool
    automated_self_heal   = bool
  })
  nullable = false

  validation {
    condition     = startswith(var.argocd_application.repo_url, "https://")
    error_message = "argocd_application.repo_url deve comecar com 'https://' (ADR-0006 D6/Opcao D e Secao 8). A forma SSH (git@github.com:...) exigiria um Secret de credencial que esta arquitetura deliberadamente NAO possui — usar 'git@' leva a Application a ComparisonError."
  }

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.argocd_application.destination_namespace))
    error_message = "argocd_application.destination_namespace deve ser um nome de namespace Kubernetes valido (RFC 1123)."
  }

  validation {
    condition     = length(trimspace(var.argocd_application.path)) > 0 && !startswith(var.argocd_application.path, "/")
    error_message = "argocd_application.path deve ser um caminho relativo dentro do repositorio (ex.: \"dvn-workshop-kubernetes\")."
  }
}

variable "tags" {
  description = "Tags adicionais alem das obrigatorias definidas em locals.tf (ADR-0006 Secao 9). Tambem usada para sobrescrever os placeholders de 'Owner' e 'CostCenter'. Aplicaveis a recursos AWS futuros desta stack — hoje ela cria apenas objetos Kubernetes."
  type        = map(string)
  nullable    = false
}
