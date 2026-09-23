############################################################################
# argocd.tf
#
# ADR-0006 (Secao 5 / D1/Opcao A / D2/Opcao C): UNICO helm_release da
# stack. Instala o chart oficial `argo-cd` e, no mesmo release, renderiza a
# Application `dvn-workshop` via `extraObjects` (values montado em
# locals.tf).
#
# NAO existe um segundo helm_release, NAO se usa o chart `argocd-apps` e
# NAO ha `depends_on` — a ordenacao CRD -> Application e resolvida pelo
# proprio Helm dentro do release.
#
# NENHUM Secret de repositorio e criado: o repositorio e publico durante o
# laboratorio e o argocd-repo-server clona ANONIMAMENTE por HTTPS/443
# atraves do NAT Gateway de 01- (ADR-0006 D6/Opcao D, Premissas 2/16/17).
# Se este arquivo um dia passar a conter credencial, a decisao D6 foi
# violada.
#
# Contrapartida aceita de D2/Opcao C (ADR-0006 Secao 11): qualquer mudanca
# na Application forca upgrade do release inteiro do ArgoCD, podendo
# reiniciar componentes. Aceito — ha uma unica Application e o ArgoCD nao
# tem SLA (sua indisponibilidade congela deploys, nao derruba aplicacao).
############################################################################

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  # Versao FIXADA (ADR-0006 Premissa 4 / criterio de aceitacao 13.3):
  # nunca a ultima implicita. Valor vem de terraform.tfvars.
  version = var.argocd.chart_version

  namespace        = var.argocd.namespace
  create_namespace = true

  values = [local.argocd_values]

  # Rollout seguro (ADR-0006 Secao 5): `atomic` remove o release em caso de
  # falha, `cleanup_on_fail` remove recursos criados por um upgrade que
  # falhou e `wait` so marca sucesso com todos os recursos prontos.
  # `timeout` ampliado por causa dos CRDs + 5 pods.
  atomic          = true
  cleanup_on_fail = true
  wait            = true
  timeout         = 900

  # Limita o historico de revisoes do Helm guardado em Secrets do cluster.
  max_history = 5
}
