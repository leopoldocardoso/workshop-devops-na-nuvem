# Deployment: 03-ecr-stack-ai

> Gerado automaticamente por `.claude/skills/terraform-deploy/deploy.sh`
> apos `terraform apply -auto-approve`. Nao editar manualmente —
> este arquivo e sobrescrito no proximo deploy desta stack.

- **Stack:** `03-ecr-stack-ai`
- **Data do apply (UTC):** 2026-09-21T14:19:06Z
- **Terraform:** Terraform v1.16.0
- **Identidade AWS que aplicou:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do apply

```
aws_ecr_repository.frontend: Creating...
aws_ecr_repository.backend: Creating...
aws_ecr_repository.frontend: Creation complete after 1s [id=dvn-workshop/production/frontend]
aws_ecr_repository.backend: Creation complete after 1s [id=dvn-workshop/production/backend]
aws_ecr_lifecycle_policy.frontend: Creating...
aws_ecr_lifecycle_policy.backend: Creating...
aws_ecr_lifecycle_policy.backend: Creation complete after 0s [id=dvn-workshop/production/backend]
aws_ecr_lifecycle_policy.frontend: Creation complete after 0s [id=dvn-workshop/production/frontend]
Releasing state lock. This may take a few moments...

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

ecr_registry_id = "659942169599"
ecr_repository_backend_arn = "arn:aws:ecr:us-east-1:659942169599:repository/dvn-workshop/production/backend"
ecr_repository_backend_name = "dvn-workshop/production/backend"
ecr_repository_backend_url = "659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/backend"
ecr_repository_frontend_arn = "arn:aws:ecr:us-east-1:659942169599:repository/dvn-workshop/production/frontend"
ecr_repository_frontend_name = "dvn-workshop/production/frontend"
ecr_repository_frontend_url = "659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend"
```

## Outputs

```json
{
  "ecr_registry_id": {
    "sensitive": false,
    "type": "string",
    "value": "659942169599"
  },
  "ecr_repository_backend_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:ecr:us-east-1:659942169599:repository/dvn-workshop/production/backend"
  },
  "ecr_repository_backend_name": {
    "sensitive": false,
    "type": "string",
    "value": "dvn-workshop/production/backend"
  },
  "ecr_repository_backend_url": {
    "sensitive": false,
    "type": "string",
    "value": "659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/backend"
  },
  "ecr_repository_frontend_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:ecr:us-east-1:659942169599:repository/dvn-workshop/production/frontend"
  },
  "ecr_repository_frontend_name": {
    "sensitive": false,
    "type": "string",
    "value": "dvn-workshop/production/frontend"
  },
  "ecr_repository_frontend_url": {
    "sensitive": false,
    "type": "string",
    "value": "659942169599.dkr.ecr.us-east-1.amazonaws.com/dvn-workshop/production/frontend"
  }
}
```

## Recursos no state

```
aws_ecr_lifecycle_policy.backend
aws_ecr_lifecycle_policy.frontend
aws_ecr_repository.backend
aws_ecr_repository.frontend
```
