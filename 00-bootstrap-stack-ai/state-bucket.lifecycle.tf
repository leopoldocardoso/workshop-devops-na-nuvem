############################################################################
# state-bucket.lifecycle.tf
#
# ADR-0002 (Secao 6.2 / 13.2): controla o custo de versoes antigas do state
# sem comprometer a capacidade de rollback (ADR-0001 Secao 12 depende de
# versioning do bucket para recuperar uma versao anterior do .tfstate).
#
#   - noncurrent_version_expiration: expira versoes nao-atuais apos
#     'state_bucket.noncurrent_version_expiration_days' dias, retendo no
#     minimo 'state_bucket.noncurrent_version_retain_count' versoes
#     recentes (newer_noncurrent_versions) independentemente da idade.
#   - abort_incomplete_multipart_upload: limpa uploads multipart
#     incompletos apos 'state_bucket.abort_incomplete_multipart_upload_days'
#     dias.
#
# Depende explicitamente do versioning estar habilitado antes (mesmo
# padrao recomendado na doc do provider para buckets com versioning).
############################################################################

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-noncurrent-state-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days           = var.state_bucket.noncurrent_version_expiration_days
      newer_noncurrent_versions = var.state_bucket.noncurrent_version_retain_count
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.state_bucket.abort_incomplete_multipart_upload_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}
