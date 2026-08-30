############################################################################
# outputs.tf
#
# ADR-0003 (Secao 13.2 / 13.3): outputs consumidos por stacks de workload
# futuras e usados na validacao pos-deploy (Secao 13.4).
#
# Nomes no padrao {name}_{type}_{attribute} (regra
# .claude/rules/terraform-naming-conventions.md, Secao 5).
############################################################################

output "eks_cluster_id" {
  description = "Nome/ID do cluster EKS."
  value       = aws_eks_cluster.this.id
}

output "eks_cluster_arn" {
  description = "ARN do cluster EKS."
  value       = aws_eks_cluster.this.arn
}

output "eks_cluster_endpoint" {
  description = "Endpoint da API do cluster EKS."
  value       = aws_eks_cluster.this.endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Dado base64 da certificate authority do cluster, usado para montar um kubeconfig (ex.: via 'aws eks update-kubeconfig')."
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "eks_cluster_security_group_id" {
  description = "ID do Security Group gerenciado automaticamente pelo EKS para comunicacao cluster<->node group (nenhum Security Group customizado e criado por esta stack — ADR-0003 Secao 8)."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_oidc_issuer_url" {
  description = "URL do issuer OIDC do cluster (fundacao IRSA, ADR-0003 Secao 3/Premissa 9)."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "eks_oidc_provider_arn" {
  description = "ARN do IAM OIDC Provider associado ao issuer do cluster (fundacao IRSA — nenhuma role de workload e criada nesta stack)."
  value       = aws_iam_openid_connect_provider.this.arn
}

output "eks_node_group_id" {
  description = "ID do EKS Managed Node Group."
  value       = aws_eks_node_group.this.id
}

output "eks_node_group_status" {
  description = "Status do EKS Managed Node Group apos o apply."
  value       = aws_eks_node_group.this.status
}

output "eks_cluster_iam_role_arn" {
  description = "ARN da IAM Role do control plane EKS."
  value       = aws_iam_role.cluster.arn
}

output "eks_node_iam_role_arn" {
  description = "ARN da IAM Role do node group EKS."
  value       = aws_iam_role.node.arn
}

output "eks_secrets_kms_key_arn" {
  description = "ARN da CMK dedicada usada em encryption_config (secrets) do cluster (ADR-0003 Secao 4/D3)."
  value       = aws_kms_key.secrets.arn
}

output "eks_cluster_log_group_name" {
  description = "Nome do CloudWatch Log Group do control plane EKS (nome fixo exigido pela integracao nativa do EKS)."
  value       = aws_cloudwatch_log_group.cluster.name
}

output "networking_vpc_id" {
  description = "ID da VPC de 01-networking-stack-ai consumida por esta stack (via data source, ADR-0003 Secao 4/D4)."
  value       = data.aws_vpc.networking.id
}

output "networking_private_subnets_ids" {
  description = "IDs das sub-redes privadas de 01-networking-stack-ai usadas pelo node group."
  value       = data.aws_subnets.private.ids
}

output "networking_public_subnets_ids" {
  description = "IDs das sub-redes publicas de 01-networking-stack-ai usadas em vpc_config.subnet_ids do cluster."
  value       = data.aws_subnets.public.ids
}
