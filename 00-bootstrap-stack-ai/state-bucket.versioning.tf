############################################################################
# state-bucket.versioning.tf
#
# ADR-0002 (Secao 6.2 / Secao 2, requisito funcional): versionamento
# habilitado — pre-requisito explicito citado no comentario de
# 01-networking-stack-ai/backend.tf e base da estrategia de rollback de
# state (ADR-0001 Secao 12).
############################################################################

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
