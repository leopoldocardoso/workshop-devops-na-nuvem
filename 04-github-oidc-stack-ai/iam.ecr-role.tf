############################################################################
# iam.ecr-role.tf
#
# ADR-0005 (Secao 5 itens 2-4, Secao 6.2, Secao 8; decisoes D2/A e D3/A):
# a UNICA IAM Role de CI da conta, assumivel pelo GitHub Actions via
# sts:AssumeRoleWithWebIdentity, e a customer managed policy de menor
# privilegio que lhe da push/pull nos 2 repositorios ECR de 03-.
#
# Toda mudanca neste arquivo e mudanca de SEGURANCA (ADR-0005 Secao 11,
# risco de impacto Alto): exige revisao de PR e re-execucao do teste de
# asserçao negativa da Secao 13.3 (assumir a role de um branch != main
# deve FALHAR).
############################################################################

# --------------------------------------------------------------------------
# Trust policy (ADR-0005 Secao 8) — documento reproduzido EXATAMENTE como
# especificado no ADR:
#
#   Effect    : Allow
#   Principal : Federated = ARN do OIDC provider criado em oidc.tf
#   Action    : sts:AssumeRoleWithWebIdentity
#   Condition : StringEquals em `aud` = sts.amazonaws.com
#               StringLike  em `sub`  = [formato classico, formato imutavel]
#                                        ambos com ref:refs/heads/main
#
# NAO generalizar, NAO acrescentar curinga, NAO remover uma das duas
# entradas de `sub` (ADR-0005 Revisao 1, nota da Secao 8).
#
# O Principal referencia o ATRIBUTO `arn` do recurso (e nao a string
# "arn:aws:iam::<account>:oidc-provider/..." montada a mao) — o valor e o
# mesmo, mas a referencia cria a dependencia implicita que garante que o
# provider exista antes da role. O account ID continua sem hardcode
# (ADR-0005 Premissa 7).
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "ecr_role_trust" {
  statement {
    sid     = "GitHubActionsAssumeRoleWithWebIdentity"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = local.oidc_audience_condition_key
      values   = [var.github_oidc.audience]
    }

    condition {
      test     = "StringLike"
      variable = local.oidc_subject_condition_key
      values   = local.github_allowed_subjects
    }
  }
}

resource "aws_iam_role" "ecr" {
  name        = local.ecr_role_name
  description = "Role assumida pelo GitHub Actions (OIDC) para build/push das imagens das apps nos repositorios ECR de 03-ecr-stack-ai. ADR-0005."

  assume_role_policy = data.aws_iam_policy_document.ecr_role_trust.json

  # ADR-0005 Secao 5 item 4: 3600 s (1 h), o default do IAM — os builds de
  # container das duas apps ficam confortavelmente abaixo disso.
  max_session_duration = 3600

  tags = merge(
    local.common_tags,
    { Name = local.ecr_role_name }
  )
}

# --------------------------------------------------------------------------
# Policy de ECR (ADR-0005 Secao 6.2, tabela "Acoes IAM da policy").
#
# Sid EcrAuthToken : ecr:GetAuthorizationToken em Resource "*" — a acao NAO
#                    suporta escopo de recurso (limitacao documentada do
#                    servico, nao folga de escopo).
# Sid EcrPushPull  : acoes de push/pull escopadas aos ARNs dos 2
#                    repositorios lidos em data.tf.
#
# BatchGetImage/GetDownloadUrlForLayer habilitam cache de camadas no build;
# DescribeImages/ListImages atendem a verificacao de existencia de tag
# exigida pelos ADR-0007/0008.
#
# NENHUMA acao destrutiva ou de configuracao e concedida: sem ecr:*, sem
# BatchDeleteImage, DeleteRepository, PutLifecyclePolicy,
# SetRepositoryPolicy; e sem qualquer acao de iam:*, sts:* adicional,
# eks:*, s3:* (ADR-0005 Secao 8 e Secao 14).
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "ecr" {
  statement {
    sid       = "EcrAuthToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "EcrPushPull"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
    ]

    resources = local.ecr_repository_arns
  }
}

resource "aws_iam_policy" "ecr" {
  name        = local.ecr_policy_name
  description = "Menor privilegio para push/pull de imagens nos repositorios ECR dvn-workshop/production/{frontend,backend}. Sem acoes destrutivas. ADR-0005 Secao 6.2."

  policy = data.aws_iam_policy_document.ecr.json

  tags = merge(
    local.common_tags,
    { Name = local.ecr_policy_name }
  )
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ecr.name
  policy_arn = aws_iam_policy.ecr.arn
}
