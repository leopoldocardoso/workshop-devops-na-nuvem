############################################################################
# eks.node-iam.tf
#
# ADR-0003 (Secao 6.2/8/13.1): IAM Role do EKS Managed Node Group. Trust
# policy restrita a ec2.amazonaws.com. Apenas as 3 policies gerenciadas
# oficiais minimas exigidas pela AWS sao anexadas — least privilege,
# nenhuma policy customizada (ADR-0003 Secao 8).
############################################################################

data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node" {
  name               = local.node_role_name
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json

  tags = merge(local.common_tags, {
    Name = local.node_role_name
  })
}

resource "aws_iam_role_policy_attachment" "node_eks_worker_node_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_eks_cni_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ec2_container_registry_read_only" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
