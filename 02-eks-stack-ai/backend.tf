############################################################################
# backend.tf
#
# ADR-0003 (Secao 13.1 passo 1): configuracao PARCIAL do backend S3, mesmo
# padrao de 01-networking-stack-ai. bucket/key/region NAO sao hardcoded
# aqui — devem ser injetados no `terraform init` via `-backend-config`
# (arquivo unico `backend.hcl`, gitignored — ver backend.hcl.example).
#
# Enquanto o `override.tf` (gitignored) estiver presente nesta stack, ele
# forca um backend "local" e este bloco "s3" e ignorado pelo Terraform —
# mesmo mecanismo ja documentado em 01-networking-stack-ai/backend.tf.
#
# Pre-requisito (bloqueante) para a migracao futura: o bucket S3 do backend
# do ADR-0002 (00-bootstrap-stack-ai) precisa estar de fato aplicado.
# Migrar esta stack para o backend S3 e uma tarefa subsequente e separada,
# fora do escopo do ADR-0003 (Secao 14) — nao antecipada por esta
# implementacao.
#
# `use_lockfile = true` habilita o locking nativo do backend S3 (requer
# Terraform CLI >= 1.10.0; o floor efetivo desta stack e >= 1.15.8, ver
# versions.tf), eliminando a necessidade de uma tabela DynamoDB dedicada.
#
# `encrypt = true` faz o backend enviar o header
# `x-amz-server-side-encryption: AES256` em todo PutObject (state e lock
# file), exigido pela bucket policy do bucket de backend (ADR-0002).
############################################################################

terraform {
  backend "s3" {
    use_lockfile = true
    encrypt      = true
  }
}
