############################################################################
# state-bucket.public-access-block.tf
#
# ADR-0002 (Secao 6.2 / Secao 2, requisito funcional): bloqueio total de
# acesso publico ao bucket — os 4 flags em true. O bucket guarda .tfstate,
# que pode conter valores sensiveis de infraestrutura.
############################################################################

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
