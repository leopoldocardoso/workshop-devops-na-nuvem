############################################################################
# outputs.tf
#
# ADR-0006 (criterio de aceitacao 13.3): expor exatamente
# `argocd_namespace_name`, `argocd_release_version` e
# `argocd_application_name`, todos com `description`.
#
# NENHUM output sensivel — o repositorio esta PUBLICO durante o laboratorio
# e o driver terraform-deploy despeja `terraform output -json` em
# docs/deployments/05-argocd-stack-ai.md (ADR-0006 Secao 11).
#
# Nomes no padrao {name}_{type}_{attribute} (regra
# .claude/rules/terraform-naming-conventions.md, Secao 5).
############################################################################

output "argocd_namespace_name" {
  description = "Namespace onde o ArgoCD foi instalado (criado pelo proprio release, create_namespace = true)."
  value       = helm_release.argocd.namespace
}

output "argocd_release_version" {
  description = "Versao FIXADA do chart argo-cd instalada pelo release (ADR-0006 Premissa 4)."
  value       = helm_release.argocd.version
}

output "argocd_application_name" {
  description = "Nome da Application GitOps renderizada via extraObjects do release (D2/Opcao C). Vazio enquanto argocd_application.enabled = false (primeira sync controlada, Secao 13.1 passos 3 e 6)."
  value       = var.argocd_application.enabled ? var.argocd_application.name : ""
}
