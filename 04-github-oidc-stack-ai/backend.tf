############################################################################
# backend.tf
#
# ADR-0005 (Secao 13.1 passo 1): configuracao PARCIAL do backend S3, mesmo
# padrao de 01-/02-/03-/05-. bucket/key/region NAO sao hardcoded aqui — sao
# injetados no `terraform init` via `-backend-config=backend.hcl` (arquivo
# gitignored, gerado a partir de backend.hcl.example).
#
# Esta stack NASCE diretamente no backend S3, sem a etapa intermediaria de
# override.tf (backend local) — o bucket do ADR-0002 (00-bootstrap-stack-ai)
# ja existe, como fez 03-.
#
# `use_lockfile = true` habilita o locking nativo do backend S3 (Terraform
# CLI >= 1.10.0; floor efetivo desta stack e >= 1.15.8), sem tabela
# DynamoDB dedicada.
#
# `encrypt = true` e OBRIGATORIO: a bucket policy do bucket de backend
# (ADR-0002, statement "DenyUnencryptedObjectUpload") nega qualquer
# PutObject sem o header x-amz-server-side-encryption.
#
# O state desta stack nao contem segredo (ADR-0005 Secao 8): apenas ARNs e
# documentos de policy.
############################################################################

terraform {
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}
