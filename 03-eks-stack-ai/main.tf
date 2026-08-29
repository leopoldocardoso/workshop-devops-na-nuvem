############################################################################
# main.tf
#
# Ponto de entrada da stack 03-eks-stack-ai (ADR-0003).
#
# Esta stack nao usa blocos `module` (ADR-0003 Secao 4 / 13.1) — todos os
# recursos sao nativos do provider hashicorp/aws, organizados em arquivos
# por dominio (regra .claude/rules/terraform-naming-conventions.md,
# Secao 2). Este arquivo nao declara recursos; serve apenas como indice de
# onde cada dominio esta implementado:
#
#   versions.tf              -> Terraform CLI + provider hashicorp/aws.
#   backend.tf                -> backend S3 (configuracao parcial, aguardando
#                                 o bucket do ADR-0002).
#   override.tf               -> backend local temporario (gitignored),
#                                 mesmo padrao ja usado em 00-/01-.
#   providers.tf              -> provider "aws" + default_tags.
#   variables.tf              -> variaveis de input (sem default).
#   data.tf                   -> VPC/sub-redes de 01-networking-stack-ai
#                                 (via data sources filtrados por tag,
#                                 ADR-0003 Secao 4/D4) + Account ID.
#   locals.tf                 -> naming, tags comuns.
#   eks.cluster-iam.tf        -> IAM Role do cluster (aws_iam_role +
#                                 policy attachment AmazonEKSClusterPolicy).
#   eks.node-iam.tf            -> IAM Role do node group (aws_iam_role + 3
#                                 policy attachments).
#   eks.encryption.tf          -> KMS CMK dedicada (envelope encryption de
#                                 Secrets, ADR-0003 Secao 4/D3).
#   eks.logging.tf             -> CloudWatch Log Group do control plane
#                                 (nome fixo, criado antes do cluster).
#   eks.tf                     -> aws_eks_cluster.this.
#   eks.oidc.tf                -> aws_iam_openid_connect_provider (fundacao
#                                 IRSA, sem roles de workload).
#   eks.node-group.tf          -> aws_eks_node_group.this.
#   outputs.tf                 -> outputs consumidos por stacks futuras.
############################################################################
