############################################################################
# eks.node-group.tf
#
# ADR-0003 (Secao 2/6.2/13.2): EKS Managed Node Group. Worker nodes
# exclusivamente em sub-redes PRIVADAS de 01-networking-stack-ai (sem IP
# publico, ADR-0003 Secao 8). capacity_type = "ON_DEMAND" e
# instance_types = ["t3.medium"] sao requisitos explicitos do solicitante
# (Secao 2) — nao alterar sem uma revisao de ADR.
#
# scaling_config.max_size (3) acima de desired_size (2): headroom para
# rolling update/rebalanceamento de AZ, sem alterar a contagem operacional
# de 2 workers solicitada (ADR-0003 Secao 6.2). update_config.max_unavailable
# limita o blast radius de atualizacoes. node_repair_config.enabled = true
# automatiza a substituicao de nos nao saudaveis (Premissa 3 — "boas
# praticas de EKS").
#
# depends_on explicito nas 3 policy attachments do node role, mesmo padrao
# do exemplo oficial do resource (validado via terraform-mcp): sem essa
# dependencia, o EKS pode falhar ao deletar instancias EC2/ENIs na
# deleção do node group.
############################################################################

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnets.private.ids

  capacity_type  = var.eks_node_group.capacity_type
  instance_types = var.eks_node_group.instance_types
  ami_type       = var.eks_node_group.ami_type
  disk_size      = var.eks_node_group.disk_size

  scaling_config {
    desired_size = var.eks_node_group.desired_size
    min_size     = var.eks_node_group.min_size
    max_size     = var.eks_node_group.max_size
  }

  update_config {
    max_unavailable = var.eks_node_group.max_unavailable
  }

  node_repair_config {
    enabled = true
  }

  tags = merge(local.common_tags, {
    Name = local.node_group_name
  })

  depends_on = [
    aws_iam_role_policy_attachment.node_eks_worker_node_policy,
    aws_iam_role_policy_attachment.node_eks_cni_policy,
    aws_iam_role_policy_attachment.node_ec2_container_registry_read_only,
  ]
}
