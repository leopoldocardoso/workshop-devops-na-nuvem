############################################################################
# backend.tf
#
# ADR-0006 (Secao 13.1 passo 2): configuracao PARCIAL do backend S3, mesmo
# padrao de 01-/02-/03-. bucket/key/region NAO sao hardcoded aqui — sao
# injetados no `terraform init` via `-backend-config=backend.hcl`
# (arquivo gitignored, gerado a partir de backend.hcl.example).
#
# Esta stack nasce diretamente no backend S3, sem a etapa intermediaria de
# override.tf (backend local) — o bucket do ADR-0002 (00-bootstrap-stack-ai)
# ja existe.
#
# `use_lockfile = true` habilita o locking nativo do backend S3, sem tabela
# DynamoDB dedicada.
#
# `encrypt = true` e OBRIGATORIO: a bucket policy do bucket de backend
# (ADR-0002, statement "DenyUnencryptedObjectUpload") nega qualquer
# PutObject sem o header x-amz-server-side-encryption.
############################################################################

terraform {
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}
