############################################################################
# oidc.tf
#
# ADR-0005 (Secao 5 item 1, Secao 6.2, D1/Opcao A): identity provider OIDC
# do GitHub Actions na conta AWS. E o emissor confiado pelo STS quando um
# job executa sts:AssumeRoleWithWebIdentity.
#
# `client_id_list` = audiencia do token (`aud`), fixada em
# sts.amazonaws.com — valor default da action oficial
# aws-actions/configure-aws-credentials (ADR-0005 Premissa 4).
#
# SEM `thumbprint_list` (ADR-0005 Premissa 5): o argumento e OPCIONAL e,
# para o GitHub, a AWS valida o certificado do IdP pela propria biblioteca
# de CAs raiz confiaveis, IGNORANDO qualquer thumbprint configurado
# (confirmado na doc do recurso, provider hashicorp/aws 6.66.0, via
# terraform-mcp em 2026-09-22). Nao fixar thumbprint evita quebra do CI a
# cada rotacao de certificado e dispensa o provider hashicorp/tls.
#
# UNICIDADE (ADR-0005 Premissa 6 / Secao 11): so pode existir UM OIDC
# provider por URL de issuer na conta. Se `token.actions.githubusercontent.com`
# ja existir (verificar com `aws iam list-open-id-connect-providers`), o
# apply falha com EntityAlreadyExists — nesse caso o caminho correto e
# IMPORTAR o provider existente, nunca recria-lo:
#
#   terraform import aws_iam_openid_connect_provider.this \
#     arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com
############################################################################

resource "aws_iam_openid_connect_provider" "this" {
  url = var.github_oidc.url

  client_id_list = [var.github_oidc.audience]

  tags = merge(
    local.common_tags,
    { Name = local.oidc_provider_name }
  )
}
