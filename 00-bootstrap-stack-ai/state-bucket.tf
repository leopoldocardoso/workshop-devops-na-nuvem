############################################################################
# state-bucket.tf
#
# ADR-0002 (Secao 6.2): bucket S3 de state e Ownership Controls.
############################################################################

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name

  # force_destroy = false (ADR-0002 Secao 11): previne destruicao acidental
  # do bucket enquanto contiver objetos — este bucket guarda o .tfstate de
  # todas as stacks consumidoras (01-, futuras).
  force_destroy = var.state_bucket.force_destroy

  tags = merge(local.common_tags, {
    Name = local.bucket_name
  })
}

# BucketOwnerEnforced desabilita ACLs por completo (ADR-0002 Secao 6.2),
# endurecendo o controle de acesso alem do Public Access Block
# (state-bucket.public-access-block.tf).
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
