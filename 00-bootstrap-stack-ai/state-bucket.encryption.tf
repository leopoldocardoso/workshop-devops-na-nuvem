############################################################################
# state-bucket.encryption.tf
#
# ADR-0002 (Secao 4, decisao D1 / Secao 6.2): criptografia padrao SSE-S3
# (AES256, chave gerenciada pela AWS) para todos os objetos gravados no
# bucket. SSE-KMS com CMK dedicada foi avaliada e descartada nesta revisao
# (Secao 4, D1 — nenhum requisito de compliance informado que a justifique).
############################################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
