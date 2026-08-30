############################################################################
# eks.encryption.tf
#
# ADR-0003 (Secao 4, decisao D3 / Secao 6.2/8): CMK dedicada para envelope
# encryption de Secrets do Kubernetes, referenciada em
# aws_eks_cluster.encryption_config (eks.tf). Rotacao anual habilitada.
#
# ATENCAO (ADR-0003 Secao 11): encryption_config so pode ser definido na
# criacao do cluster — nao e aplicavel in-place a um cluster ja existente
# sem esse bloco. Confirmar a presenca deste bloco no `plan` antes do
# primeiro `apply` (Secao 13.1 passo 4).
############################################################################

resource "aws_kms_key" "secrets" {
  description             = "CMK dedicada para envelope encryption de Secrets do cluster EKS ${local.cluster_name} (ADR-0003 Secao 4/D3)."
  enable_key_rotation     = true
  deletion_window_in_days = var.eks_secrets_encryption.kms_deletion_window_days

  tags = merge(local.common_tags, {
    Name = local.kms_alias_name
  })
}

resource "aws_kms_alias" "secrets" {
  name          = "alias/${local.kms_alias_name}"
  target_key_id = aws_kms_key.secrets.key_id
}
