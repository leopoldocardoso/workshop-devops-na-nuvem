############################################################################
# eks.tf
#
# ADR-0003 (Secao 4/5/6.2/8, decisoes D1/D2/D3): EKS Cluster (control
# plane). Consome VPC/sub-redes de 01-networking-stack-ai via data sources
# (data.tf, Secao 4/D4) — 2 sub-redes publicas + 2 privadas em vpc_config,
# conforme Secao 6.2.
#
# depends_on explicito na policy attachment do cluster e no log group,
# mesmo padrao do exemplo oficial do resource (validado via terraform-mcp):
# sem essa dependencia, o EKS pode falhar ao destruir a infraestrutura EC2
# gerenciada (Security Groups) na deleção do cluster.
#
# lifecycle.prevent_destroy = true (ADR-0003 Secao 11, risco "Delecao
# acidental do cluster" — avaliacao explicitamente delegada ao
# devops-engineer na implementacao): bloqueia `terraform destroy`/um
# `apply` que substitua este recurso enquanto o bloco permanecer presente.
# ATENCAO: uma mudanca legitima que force replacement (ex.: downgrade de
# versao — nao suportado; ou alteracao de kubernetes_network_config /
# vpc_config.subnet_ids que force recriacao) tambem sera bloqueada por
# este lifecycle — remover a linha deliberadamente, em um commit proprio
# e revisado, antes de aplicar uma mudanca desse tipo (ver README.md >
# Pontos de Atencao / Rollback).
############################################################################

resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_cluster.kubernetes_version

  enabled_cluster_log_types = var.eks_cluster.enabled_log_types

  vpc_config {
    subnet_ids = concat(
      data.aws_subnets.public.ids,
      data.aws_subnets.private.ids,
    )

    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.eks_cluster.endpoint_public_access_cidrs
  }

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = aws_kms_key.secrets.arn
    }
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = merge(local.common_tags, {
    Name = local.cluster_name
  })

  # Garante que as permissoes de IAM existam antes da criacao do cluster e
  # sejam removidas apenas depois — caso contrario o EKS nao consegue
  # deletar a infraestrutura EC2 gerenciada (Security Groups) na deleção
  # (exemplo oficial do resource, validado via terraform-mcp). O log group
  # e criado antes do cluster para garantir a retencao configurada desde o
  # primeiro log entregue (ADR-0003 Secao 6.2).
  depends_on = [
    aws_iam_role_policy_attachment.cluster_eks_cluster_policy,
    aws_cloudwatch_log_group.cluster,
  ]

  lifecycle {
    prevent_destroy = true
  }
}
