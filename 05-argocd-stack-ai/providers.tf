############################################################################
# providers.tf
#
# ADR-0006 (Secao 13.1 passo 3 / Premissas 1, 5 e 6).
#
# provider "aws": regiao parametrizada e default_tags com as tags
# obrigatorias (local.common_tags). Hoje esta stack nao cria recursos AWS —
# as default_tags existem para o caso de algum recurso AWS ser adicionado.
#
# provider "helm": autentica no cluster EKS pelo ENDPOINT PUBLICO RESTRITO
# da API (ADR-0003 D2/A) usando credencial efemera via `exec`
# (`aws eks get-token`). NUNCA `config_path` de kubeconfig local — o
# kubeconfig do operador ja se provou instavel neste repositorio (endpoint
# antigo apos recriacao do cluster).
#
# Sintaxe: no provider helm v3 `kubernetes` e um ATRIBUTO (`= { ... }`),
# nao um bloco; `exec` idem. Confirmado na doc do provider 3.3.0 via
# terraform-mcp em 2026-09-22.
#
# Consequencia operacional (ADR-0006 Secao 11): se o IP de saida de quem
# roda o Terraform nao estiver em `public_access_cidrs` do cluster, tanto o
# plan quanto o apply falham por timeout. A correcao e em 02-eks-stack-ai —
# FORA do escopo desta stack.
############################################################################

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        data.aws_eks_cluster.this.name,
        "--region",
        var.aws_region,
      ]
    }
  }
}
