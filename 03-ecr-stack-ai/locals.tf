############################################################################
# locals.tf
#
# ADR-0004 (Secao 9 / 13.1): ambiente fixo, nomes dos repositorios e tags
# comuns. Mesmo padrao de 00-/01-/02- (Revisao 5 do ADR-0001): ambiente
# unico "prd", fixo como local — nao existe variable "environment".
############################################################################

locals {
  # Ambiente unico desta stack (ADR-0004 Premissa 1). Nao e um input.
  environment = "prd"

  # --------------------------------------------------------------------
  # Nomes dos repositorios ECR (ADR-0004 Secao 4/D1, Secao 9):
  # path-style `{namespace}/{environment_segment}/{app}`, literalmente
  # como pedido pelo solicitante — "dvn-workshop/production/frontend" e
  # "dvn-workshop/production/backend". Contrato externo (docker push/pull,
  # `image:` de manifestos futuros), por isso NAO segue o padrao interno
  # {env}-{project_name}-{service}-{region}. O segmento "production" e
  # parte da URI de imagem e nao e forcado a coincidir com o valor "prd"
  # da tag Environment.
  # --------------------------------------------------------------------
  repository_name_prefix = "${var.ecr.namespace}/${var.ecr.environment_segment}"

  repository_names = {
    frontend = "${local.repository_name_prefix}/frontend"
    backend  = "${local.repository_name_prefix}/backend"
  }

  # --------------------------------------------------------------------
  # Lifecycle policy (ADR-0004 Secao 4/D4) — documento unico reutilizado
  # pelos dois repositorios. Regras em ordem crescente de rulePriority
  # (a API do ECR reordena por prioridade; manter ascendente evita
  # recriacao espúria a cada plan).
  #   1. Expira imagens NAO tageadas com mais de N dias (sinceImagePushed).
  #   2. Mantem apenas as N imagens tageadas mais recentes
  #      (tagStatus "tagged" + tagPatternList ["*"] = qualquer tag).
  # --------------------------------------------------------------------
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expira imagens nao tageadas com mais de ${var.ecr_lifecycle.untagged_expire_days} dias"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.ecr_lifecycle.untagged_expire_days
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Mantem apenas as ${var.ecr_lifecycle.tagged_keep_count} imagens tageadas mais recentes"
        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"]
          countType      = "imageCountMoreThan"
          countNumber    = var.ecr_lifecycle.tagged_keep_count
        }
        action = {
          type = "expire"
        }
      },
    ]
  })

  # --------------------------------------------------------------------
  # Tags obrigatorias (ADR-0004, Secao 9). Aplicadas via default_tags do
  # provider (providers.tf) E reforcadas individualmente em cada recurso
  # (merge(local.common_tags, { Name = "..." })), mesmo padrao de
  # 00-/01-/02-.
  #
  # ATENCAO: 'Owner' e 'CostCenter' nao possuem valor definitivo no
  # ADR-0004 ("a definir pelo solicitante" — Secao 9 / Premissa 10). Os
  # placeholders abaixo DEVEM ser sobrescritos via var.tags
  # (terraform.tfvars) antes do apply real. Ver README.md.
  #
  # 'DataClassification' = "internal" (ADR-0004 Secao 9): imagens de
  # container nao devem conter segredos; menos restritiva que
  # "confidential" de 02- (Secrets do Kubernetes), mais restritiva que
  # "public" (repositorios privados).
  # --------------------------------------------------------------------
  common_tags = merge(
    {
      Environment        = local.environment
      Owner              = "AJUSTAR-time-responsavel"
      CostCenter         = "AJUSTAR-centro-de-custo"
      Project            = var.project_name
      ManagedBy          = "terraform"
      DataClassification = "internal"
      StackName          = "03-ecr-stack-ai"
    },
    var.tags
  )
}
