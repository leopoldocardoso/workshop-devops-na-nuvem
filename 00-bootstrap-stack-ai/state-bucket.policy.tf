############################################################################
# state-bucket.policy.tf
#
# ADR-0002 (Secao 6.2 / Secao 8): bucket policy com 3 clausulas de negacao,
# construida via data.aws_iam_policy_document (nenhuma concessao de acesso
# amplo — a politica apenas nega, reforcando controles ja existentes):
#
#   1. deny_insecure_transport: nega qualquer requisicao sem TLS
#      (aws:SecureTransport = false), seguindo a orientacao "How do I
#      enforce TLS 1.2 or later for my S3 buckets?" (AWS re:Post).
#   2. deny_unencrypted_object_upload: nega PutObject que nao especifique
#      SSE-S3 (AES256) no header da requisicao.
#   3. deny_principals_outside_account: nega qualquer acao a principals
#      fora da conta AWS atual (aws:PrincipalAccount != account_id).
############################################################################

data "aws_iam_policy_document" "state_bucket" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "DenyUnencryptedObjectUpload"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:PutObject"]

    resources = ["${aws_s3_bucket.this.arn}/*"]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }

  statement {
    sid    = "DenyPrincipalsOutsideAccount"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.state_bucket.json

  depends_on = [aws_s3_bucket_public_access_block.this]
}
