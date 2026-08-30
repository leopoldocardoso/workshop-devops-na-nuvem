############################################################################
# locals.tf
#
# ADR-0003 (Secao 9 / 13.1): nomes padronizados e tags comuns. Mesmo padrao
# de 00-/01- (Revisao 5 do ADR-0001): ambiente unico "prd", fixo como
# local — nao existe variable "environment" nesta stack.
############################################################################

locals {
  # Ambiente unico desta stack (ADR-0003 Secao 3, Premissa 1 — herdado da
  # Revisao 5 do ADR-0001/ADR-0002). Nao e um input Terraform.
  environment = "prd"

  # Prefixo de naming convention: {env}-{project_name}
  # (ADR-0003 Secao 9: "{env}-{project_name}-{service}-{region}", com o
  # segmento {service} omitido quando redundante com project_name, ex.:
  # "prd-eks-sa-east-1" para o cluster, nao "prd-eks-cluster-sa-east-1").
  name = "${local.environment}-${var.project_name}"

  # Nomes de negocio dos recursos principais (ADR-0003 Secao 6.2/9).
  cluster_name      = "${local.name}-${var.aws_region}"
  node_group_name   = "${local.name}-ng-${var.aws_region}"
  cluster_role_name = "${local.name}-cluster-role-${var.aws_region}"
  node_role_name    = "${local.name}-node-role-${var.aws_region}"
  kms_alias_name    = "${local.name}-secrets-${var.aws_region}"
  oidc_name         = "${local.name}-oidc-${var.aws_region}"

  # Nome do CloudWatch Log Group do control plane: FIXO, exigido pela
  # integracao nativa do EKS control plane logging (ADR-0003 Secao 6.2) —
  # nao e uma escolha livre de naming convention.
  cluster_log_group_name = "/aws/eks/${local.cluster_name}/cluster"

  # --------------------------------------------------------------------
  # Tags obrigatorias (ADR-0003, Secao 9). Aplicadas via default_tags do
  # provider (providers.tf) E reforcadas individualmente em cada recurso
  # nativo (merge(local.common_tags, { Name = "..." })), mesmo padrao de
  # 00-/01-.
  #
  # ATENCAO: 'Owner' e 'CostCenter' nao possuem valor definitivo no
  # ADR-0003 ("a definir pelo solicitante" — Secao 9). Os placeholders
  # abaixo DEVEM ser sobrescritos via var.tags (terraform.tfvars, na raiz
  # da stack) antes do apply real. Ver README.md > Pontos de Atencao.
  #
  # 'DataClassification' e "confidential" (mais restritiva que "internal"
  # de 01-) — o cluster hospedara Secrets/credenciais de aplicacoes
  # futuras (ADR-0003 Secao 9).
  # --------------------------------------------------------------------
  common_tags = merge(
    {
      Environment        = local.environment
      Owner              = "Leopoldo Peixoto Cardoso"
      CostCenter         = "workshop-devops-na-nuvem"
      Project            = var.project_name
      ManagedBy          = "terraform"
      DataClassification = "confidential"
      StackName          = "02-eks-stack-ai"
    },
    var.tags
  )
}
