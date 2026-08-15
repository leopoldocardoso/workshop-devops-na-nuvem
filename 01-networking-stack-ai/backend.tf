############################################################################
# backend.tf
#
# ADR-0001 (Secao 13.1 passo 4 / Secao 6.3 / Premissa 8): configuracao PARCIAL
# do backend S3. bucket/key/region NAO sao hardcoded aqui — devem ser
# injetados no `terraform init` via `-backend-config` (arquivo unico
# `backend.hcl`, sem sufixo de ambiente — Revisao 5 do ADR-0001: a stack
# passa a ter um unico ambiente, "prd") para evitar segredos/valores de
# conta versionados neste arquivo.
#
# Pre-requisito (bloqueante): o bucket S3 do backend (com versioning e SSE
# habilitados) precisa existir previamente. Seu provisionamento esta fora do
# escopo desta stack — assumido como responsabilidade de uma stack de
# bootstrap separada (ex.: 00-bootstrap), conforme Premissa 8 e Secao 14
# (Non-goals) do ADR-0001.
#
# `use_lockfile = true` habilita o locking nativo do backend S3 (requer
# Terraform CLI >= 1.10.0; o floor efetivo desta stack e >= 1.15.8, ver
# versions.tf), eliminando a necessidade de uma tabela DynamoDB dedicada
# para locking.
############################################################################

terraform {
  backend "s3" {
    use_lockfile = true
  }
}
