############################################################################
# variables.tf
#
# ADR-0005 (Secao 13.2): variaveis de input da stack.
#
# Estrutura em conformidade com .claude/rules/terraform-naming-conventions.md
# (Secao 4): variaveis do mesmo dominio agrupadas em object(...)
# (`github_oidc`, `ecr`); variaveis verdadeiramente cross-dominio
# (aws_region, project_name, tags) permanecem standalone. NENHUMA variavel
# declara `default` — os valores efetivos ficam em terraform.tfvars, na
# raiz da stack (ver terraform.tfvars.example).
#
# Sem `variable "environment"` — mesmo padrao de 00-/01-/02-/03-/05-:
# local.environment fixo em "prd" (locals.tf).
############################################################################

variable "aws_region" {
  description = "Regiao AWS usada pelo provider e pelos data sources de ECR, e sufixo dos nomes de negocio (ADR-0005: us-east-1). Os recursos IAM em si sao globais."
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "Nome logico da stack, usado na tag 'Project' e no prefixo dos nomes de negocio {env}-{project_name}-{service}-{region} (ADR-0005 Premissa 11: \"github-oidc\")."
  type        = string
  nullable    = false
}

# ----------------------------------------------------------------------
# Dominio "github_oidc": federacao OIDC entre GitHub Actions e AWS
# (ADR-0005 Secao 5, decisoes D1/A e D2/A; Premissas 2, 3 e 4).
#
# ATENCAO (ADR-0005 Secao 8, nota da Revisao 1): `allowed_branch` compoe a
# condicao `sub` da trust policy. Com o repositorio PUBLICO durante o
# laboratorio, essa condicao deixou de ser higiene e passou a ser o
# CONTROLE DE FRONTEIRA entre uma contribuicao externa (fork/PR de
# qualquer pessoa) e o registry de `prd`. Alargar esse escopo e uma
# MUDANCA DE SEGURANCA, que exige revisao propria do ADR-0005 — nunca um
# ajuste de conveniencia para "destravar" um pipeline.
# ----------------------------------------------------------------------
variable "github_oidc" {
  description = "Configuracao agregada da federacao OIDC com o GitHub Actions: `url` do issuer (https://token.actions.githubusercontent.com), `audience` (`aud` do token; sts.amazonaws.com, default da action aws-actions/configure-aws-credentials), `repository_owner`/`repository_name` (compoem o claim `sub` nos formatos classico e imutavel — ADR-0005 Premissa 2) e `allowed_branch` (unica ref autorizada a assumir a role; ADR-0005 D2/Opcao A)."
  type = object({
    url              = string
    audience         = string
    repository_owner = string
    repository_name  = string
    allowed_branch   = string
  })
  nullable = false

  validation {
    condition     = startswith(var.github_oidc.url, "https://")
    error_message = "github_oidc.url deve comecar com https:// (valor do ADR-0005: https://token.actions.githubusercontent.com)."
  }

  validation {
    condition     = length(var.github_oidc.audience) > 0 && !strcontains(var.github_oidc.audience, "*")
    error_message = "github_oidc.audience nao pode ser vazio nem conter '*' — a condicao de `aud` e StringEquals exato (ADR-0005 Premissa 4: sts.amazonaws.com)."
  }

  validation {
    condition     = length(var.github_oidc.repository_owner) > 0 && !strcontains(var.github_oidc.repository_owner, "*")
    error_message = "github_oidc.repository_owner nao pode ser vazio nem conter '*'. Um curinga na posicao do owner casaria com owners como 'leopoldocardoso-x' e entregaria credencial de push em prd a terceiros (ADR-0005 Secao 8)."
  }

  validation {
    condition     = length(var.github_oidc.repository_name) > 0 && !strcontains(var.github_oidc.repository_name, "*")
    error_message = "github_oidc.repository_name nao pode ser vazio nem conter '*' (ADR-0005 Secao 8 / D2 Opcao C descartada por escopo excessivo)."
  }

  validation {
    condition     = length(var.github_oidc.allowed_branch) > 0 && !strcontains(var.github_oidc.allowed_branch, "*")
    error_message = "github_oidc.allowed_branch nao pode ser vazio nem conter '*'. A ref e escrita explicitamente (ref:refs/heads/main) — um '*' na posicao da ref e exatamente o risco de impacto Alto da Secao 11 do ADR-0005."
  }
}

# ----------------------------------------------------------------------
# Dominio "ecr": nomes dos repositorios criados por 03-ecr-stack-ai
# (ADR-0004), lidos aqui via data source e usados para escopar a policy
# por ARN. Esta stack NAO cria nem altera repositorios ECR
# (ADR-0005 Premissa 9 / Secao 14).
# ----------------------------------------------------------------------
variable "ecr" {
  description = "Nomes path-style dos repositorios ECR existentes (criados por 03-ecr-stack-ai) aos quais a role de CI recebe permissao de push/pull: `frontend_repository_name` e `backend_repository_name`. Somente leitura — nenhum repositorio e criado ou alterado por esta stack."
  type = object({
    frontend_repository_name = string
    backend_repository_name  = string
  })
  nullable = false

  validation {
    condition     = length(var.ecr.frontend_repository_name) > 0 && !strcontains(var.ecr.frontend_repository_name, "*")
    error_message = "ecr.frontend_repository_name nao pode ser vazio nem conter '*' — o ARN do repositorio escopa a policy e nao admite curinga (ADR-0005 Secao 6.2)."
  }

  validation {
    condition     = length(var.ecr.backend_repository_name) > 0 && !strcontains(var.ecr.backend_repository_name, "*")
    error_message = "ecr.backend_repository_name nao pode ser vazio nem conter '*' — o ARN do repositorio escopa a policy e nao admite curinga (ADR-0005 Secao 6.2)."
  }
}

variable "tags" {
  description = "Tags adicionais mescladas as tags obrigatorias definidas em locals.tf (ADR-0005 Secao 9)."
  type        = map(string)
  nullable    = false
}
