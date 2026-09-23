############################################################################
# locals.tf
#
# ADR-0005 (Secao 9): ambiente fixo, nomes de negocio, os dois formatos do
# claim `sub` aceitos pela trust policy e as tags comuns.
#
# Mesmo padrao de 00-/01-/02-/03-/05- (Revisao 5 do ADR-0001): ambiente
# unico "prd", fixo como local — nao existe variable "environment".
############################################################################

locals {
  # Ambiente unico desta stack (ADR-0005, cabecalho). Nao e um input.
  environment = "prd"

  # --------------------------------------------------------------------
  # Nomes de negocio (ADR-0005 Secao 9): {env}-{project_name}-{service}-{region}
  #   prd-github-oidc-us-east-1             -> tag Name do OIDC provider
  #                                            (o identificador real do
  #                                            recurso e a URL do issuer)
  #   prd-github-oidc-ecr-role-us-east-1    -> IAM Role de CI
  #   prd-github-oidc-ecr-policy-us-east-1  -> IAM Policy de ECR
  # --------------------------------------------------------------------
  name_prefix = "${local.environment}-${var.project_name}"

  oidc_provider_name = "${local.name_prefix}-${var.aws_region}"
  ecr_role_name      = "${local.name_prefix}-ecr-role-${var.aws_region}"
  ecr_policy_name    = "${local.name_prefix}-ecr-policy-${var.aws_region}"

  # --------------------------------------------------------------------
  # Host do issuer, sem o esquema — e o prefixo das condition keys do
  # mapeamento OIDC default ("token.actions.githubusercontent.com:aud" e
  # ":sub"). ADR-0005 Premissa 3: `aud` e `sub` sao as unicas chaves
  # utilizaveis aqui; nao existe condition key de repository_owner/id.
  # --------------------------------------------------------------------
  oidc_issuer_host = replace(var.github_oidc.url, "https://", "")

  oidc_audience_condition_key = "${local.oidc_issuer_host}:aud"
  oidc_subject_condition_key  = "${local.oidc_issuer_host}:sub"

  # --------------------------------------------------------------------
  # Claim `sub` aceito — ADR-0005 Premissa 2 e Secao 8.
  #
  # Duas entradas literais da MESMA condicao (semantica OR), cobrindo os
  # dois formatos que o GitHub pode emitir:
  #
  #   1. Formato CLASSICO (repositorios anteriores a 15/07/2026):
  #      repo:<owner>/<repo>:ref:refs/heads/<branch>
  #   2. Formato IMUTAVEL (repositorios criados a partir de 15/07/2026):
  #      repo:<owner>@<ORG_ID>/<repo>@<REPO_ID>:ref:refs/heads/<branch>
  #
  # O `@*` aparece APENAS onde o GitHub insere IDs numericos, sempre
  # DEPOIS do nome literal do owner/repo — nunca como curinga de owner.
  # NAO escrever "repo:<owner>*/..." (casaria com owners como
  # "leopoldocardoso-x"), nem "*" na posicao da ref.
  #
  # Com o repositorio PUBLICO durante o laboratorio (ADR-0005 Premissa 1,
  # Revisao 1), o fragmento ":ref:refs/heads/main" e o controle de
  # fronteira entre uma contribuicao externa e o registry de prd. Alargar
  # esta condicao e mudanca de seguranca, em revisao propria do ADR-0005.
  # --------------------------------------------------------------------
  github_subject_classic = "repo:${var.github_oidc.repository_owner}/${var.github_oidc.repository_name}:ref:refs/heads/${var.github_oidc.allowed_branch}"

  github_subject_immutable = "repo:${var.github_oidc.repository_owner}@*/${var.github_oidc.repository_name}@*:ref:refs/heads/${var.github_oidc.allowed_branch}"

  github_allowed_subjects = [
    local.github_subject_classic,
    local.github_subject_immutable,
  ]

  # --------------------------------------------------------------------
  # ARNs dos repositorios ECR alvo (ADR-0004), lidos via data source.
  # Escopo de recurso da statement EcrPushPull da policy.
  # --------------------------------------------------------------------
  ecr_repository_arns = [
    data.aws_ecr_repository.frontend.arn,
    data.aws_ecr_repository.backend.arn,
  ]

  # --------------------------------------------------------------------
  # Tags obrigatorias (ADR-0005 Secao 9). Aplicadas via default_tags do
  # provider (providers.tf) E reforcadas individualmente em cada recurso
  # que suporta tags (merge(local.common_tags, { Name = "..." })), mesmo
  # padrao de 02-/03-.
  #
  # 'Owner' e 'CostCenter' tem valor DEFINITIVO neste ADR (Premissa 10) —
  # diferentemente de 03-/05-, aqui nao ha placeholder "AJUSTAR-".
  #
  # 'DataClassification' = "confidential" (ADR-0005 Secao 9): a role
  # concede escrita em um registry de producao.
  # --------------------------------------------------------------------
  common_tags = merge(
    {
      Environment        = local.environment
      Owner              = "Leopoldo Peixoto Cardoso"
      CostCenter         = "workshop-devops-na-nuvem"
      Project            = var.project_name
      ManagedBy          = "terraform"
      DataClassification = "confidential"
      StackName          = "04-github-oidc-stack-ai"
    },
    var.tags
  )
}
