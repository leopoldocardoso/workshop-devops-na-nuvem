############################################################################
# main.tf
#
# Ponto de entrada da stack 05-argocd-stack-ai (ADR-0006, Revisao 3).
#
# Esta stack nao usa blocos `module` (ADR-0006 Secao 6.3 — nenhum modulo de
# terceiros, padrao do repositorio). Este arquivo nao declara recursos;
# serve como indice de onde cada dominio esta implementado:
#
#   versions.tf   -> Terraform CLI + providers hashicorp/aws e
#                    hashicorp/helm, ambos com versao pinada.
#   backend.tf    -> backend S3 (configuracao parcial; backend.hcl).
#   providers.tf  -> provider "aws" (default_tags) e provider "helm"
#                    autenticando no EKS via exec `aws eks get-token`.
#   data.tf       -> data.aws_eks_cluster do cluster de 02-eks-stack-ai.
#   variables.tf  -> variaveis de input (sem default).
#   locals.tf     -> ambiente fixo "prd", tags, sizing e o `values` do
#                    chart, incluindo a Application via extraObjects.
#   argocd.tf     -> helm_release.argocd (UNICO release da stack).
#   outputs.tf    -> namespace, versao do chart e nome da Application.
#
# Escopo estrito (ADR-0006 Secoes 13 e 14): instalar o ArgoCD e declarar
# UMA Application apontando para dvn-workshop-kubernetes/ deste
# repositorio. Nenhum Secret/credencial (D6/Opcao D — repositorio publico,
# clone anonimo por HTTPS), nenhum Ingress/LoadBalancer, nenhuma alteracao
# em 00-/01-/02-/03- e nenhuma alteracao em dvn-workshop-kubernetes/.
############################################################################
