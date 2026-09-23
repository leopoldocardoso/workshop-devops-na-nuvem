############################################################################
# data.tf
#
# ADR-0006 (Secao 6.2): leitura do cluster EKS criado por 02-eks-stack-ai
# (ADR-0003). Somente leitura — esta stack nao altera uma linha de 02-.
#
# Fornece `endpoint` e `certificate_authority` ao provider helm
# (providers.tf). O token de autenticacao NAO vem de
# data.aws_eks_cluster_auth: usa-se `exec` com `aws eks get-token`, que
# renova a credencial a cada operacao e nao persiste token no state
# (ADR-0006 Premissa 6).
#
# Acoplamento conhecido: o nome do cluster e um input (var.eks.cluster_name),
# nao um `terraform_remote_state` — mesmo principio de desacoplamento usado
# por 02- em relacao a 01-.
############################################################################

data "aws_eks_cluster" "this" {
  name = var.eks.cluster_name
}
