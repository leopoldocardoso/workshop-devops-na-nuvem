############################################################################
# eks.cluster-iam.tf
#
# ADR-0003 (Secao 6.2/8/13.1): IAM Role do control plane EKS. Trust policy
# restrita a eks.amazonaws.com (sts:AssumeRole + sts:TagSession, exemplo
# oficial do resource aws_eks_cluster, validado via terraform-mcp). Apenas
# a policy gerenciada oficial AmazonEKSClusterPolicy e anexada — least
# privilege, nenhuma policy customizada (ADR-0003 Secao 8).
############################################################################

data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name               = local.cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json

  tags = merge(local.common_tags, {
    Name = local.cluster_role_name
  })
}

resource "aws_iam_role_policy_attachment" "cluster_eks_cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
