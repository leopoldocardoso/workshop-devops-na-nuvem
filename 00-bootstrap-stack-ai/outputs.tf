############################################################################
# outputs.tf
#
# ADR-0002 (Secao 13.1 passo 7 / Secao 13.3): outputs consumidos por
# stacks consumidoras (01-networking-stack-ai e futuras) para referencia do
# nome/ARN do bucket de backend remoto ao construir seus respectivos
# backend.hcl.
#
# Nomes seguem o padrao {name}_{type}_{attribute} (regra
# .claude/rules/terraform-naming-conventions.md, Secao 5).
############################################################################

output "state_bucket_id" {
  description = "Nome (ID) do bucket S3 de state, a ser usado como 'bucket' em backend.hcl das stacks consumidoras."
  value       = aws_s3_bucket.this.id
}

output "state_bucket_arn" {
  description = "ARN do bucket S3 de state."
  value       = aws_s3_bucket.this.arn
}
