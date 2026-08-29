############################################################################
# eks.logging.tf
#
# ADR-0003 (Secao 6.2/8/13.1): CloudWatch Log Group do control plane EKS.
# Nome FIXO (/aws/eks/{cluster_name}/cluster), exigido pela integracao
# nativa do EKS control plane logging — criado ANTES do cluster (eks.tf)
# para controlar a retencao desde o primeiro log, evitando a retencao
# "never expire" default da AWS.
############################################################################

resource "aws_cloudwatch_log_group" "cluster" {
  name              = local.cluster_log_group_name
  retention_in_days = var.eks_cluster.log_retention_days

  tags = merge(local.common_tags, {
    Name = local.cluster_log_group_name
  })
}
