# Deployment: 00-bootstrap-stack-ai

> Gerado automaticamente por `.claude/skills/terraform-deploy/deploy.sh`
> apos `terraform apply -auto-approve`. Nao editar manualmente —
> este arquivo e sobrescrito no proximo deploy desta stack.

- **Stack:** `00-bootstrap-stack-ai`
- **Data do apply (UTC):** 2026-08-30T15:28:13Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que aplicou:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do apply

```
aws_s3_bucket.this: Creating...
aws_s3_bucket.this: Creation complete after 5s [id=prd-bootstrap-tfstate-659942169599-us-east-1]
aws_s3_bucket_ownership_controls.this: Creating...
aws_s3_bucket_versioning.this: Creating...
aws_s3_bucket_public_access_block.this: Creating...
aws_s3_bucket_server_side_encryption_configuration.this: Creating...
data.aws_iam_policy_document.state_bucket: Reading...
data.aws_iam_policy_document.state_bucket: Read complete after 0s [id=2977087446]
aws_s3_bucket_public_access_block.this: Creation complete after 0s [id=prd-bootstrap-tfstate-659942169599-us-east-1]
aws_s3_bucket_policy.this: Creating...
aws_s3_bucket_ownership_controls.this: Creation complete after 0s [id=prd-bootstrap-tfstate-659942169599-us-east-1]
aws_s3_bucket_policy.this: Creation complete after 1s [id=prd-bootstrap-tfstate-659942169599-us-east-1]
aws_s3_bucket_server_side_encryption_configuration.this: Creation complete after 1s [id=prd-bootstrap-tfstate-659942169599-us-east-1]
aws_s3_bucket_versioning.this: Creation complete after 2s [id=prd-bootstrap-tfstate-659942169599-us-east-1]
aws_s3_bucket_lifecycle_configuration.this: Creating...
aws_s3_bucket_lifecycle_configuration.this: Still creating... [00m10s elapsed]
aws_s3_bucket_lifecycle_configuration.this: Still creating... [00m20s elapsed]
aws_s3_bucket_lifecycle_configuration.this: Still creating... [00m30s elapsed]
aws_s3_bucket_lifecycle_configuration.this: Still creating... [00m40s elapsed]
aws_s3_bucket_lifecycle_configuration.this: Still creating... [00m50s elapsed]
aws_s3_bucket_lifecycle_configuration.this: Creation complete after 57s [id=prd-bootstrap-tfstate-659942169599-us-east-1]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

state_bucket_arn = "arn:aws:s3:::prd-bootstrap-tfstate-659942169599-us-east-1"
state_bucket_id = "prd-bootstrap-tfstate-659942169599-us-east-1"
```

## Outputs

```json
{
  "state_bucket_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:s3:::prd-bootstrap-tfstate-659942169599-us-east-1"
  },
  "state_bucket_id": {
    "sensitive": false,
    "type": "string",
    "value": "prd-bootstrap-tfstate-659942169599-us-east-1"
  }
}
```

## Recursos no state

```
data.aws_caller_identity.current
data.aws_iam_policy_document.state_bucket
aws_s3_bucket.this
aws_s3_bucket_lifecycle_configuration.this
aws_s3_bucket_ownership_controls.this
aws_s3_bucket_policy.this
aws_s3_bucket_public_access_block.this
aws_s3_bucket_server_side_encryption_configuration.this
aws_s3_bucket_versioning.this
```
