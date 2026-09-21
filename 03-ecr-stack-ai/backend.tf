############################################################################
# backend.tf
#
# ADR-0004 (Secao 13.1 passo 1): configuracao PARCIAL do backend S3, mesmo
# padrao de 01-/02-. bucket/key/region NAO sao hardcoded aqui — sao
# injetados no `terraform init` via `-backend-config=backend.hcl`
# (arquivo gitignored, gerado a partir de backend.hcl.example).
#
# Pre-requisito: o bucket de state do ADR-0002 (00-bootstrap-stack-ai) ja
# existe, com versioning e SSE habilitados — por isso esta stack nasce
# diretamente no backend S3, sem a etapa intermediaria de override.tf
# (backend local) que 01-/02- percorreram antes de suas migracoes.
#
# `use_lockfile = true` habilita o locking nativo do backend S3 (Terraform
# CLI >= 1.10.0; floor efetivo desta stack e >= 1.15.8, ver versions.tf),
# sem tabela DynamoDB dedicada.
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
