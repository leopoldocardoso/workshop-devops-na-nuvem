############################################################################
# eks.oidc.tf
#
# ADR-0003 (Secao 3, Premissa 9): fundacao de IRSA (IAM Roles for Service
# Accounts) via IAM OIDC Provider. Nenhuma IAM Role de workload/service
# account e criada nesta stack (Non-goal, Secao 14) — apenas o provider.
#
# thumbprint_list omitido deliberadamente: a IAM resolve automaticamente o
# thumbprint para o issuer do EKS (confirmado via terraform-mcp, resource
# aws_iam_openid_connect_provider, provider 6.62.0) — elimina a necessidade
# de um provider adicional (hashicorp/tls) so para calcula-lo, mantendo a
# stack restrita ao provider hashicorp/aws.
############################################################################

resource "aws_iam_openid_connect_provider" "this" {
  url            = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]

  tags = merge(local.common_tags, {
    Name = local.oidc_name
  })
}
