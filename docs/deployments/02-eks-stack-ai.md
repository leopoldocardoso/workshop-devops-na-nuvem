# Deployment: 02-eks-stack-ai

> Gerado automaticamente por `.claude/skills/terraform-deploy/deploy.sh`
> apos `terraform apply -auto-approve`. Nao editar manualmente —
> este arquivo e sobrescrito no proximo deploy desta stack.

- **Stack:** `02-eks-stack-ai`
- **Data do apply (UTC):** 2026-09-21T14:13:12Z
- **Terraform:** Terraform v1.16.0
- **Identidade AWS que aplicou:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do apply

```
aws_iam_role.cluster: Creating...
aws_kms_key.secrets: Creating...
aws_cloudwatch_log_group.cluster: Creating...
aws_iam_role.node: Creating...
aws_iam_role.cluster: Creation complete after 1s [id=prd-eks-cluster-role-us-east-1]
aws_iam_role_policy_attachment.cluster_eks_cluster_policy: Creating...
aws_cloudwatch_log_group.cluster: Creation complete after 2s [id=/aws/eks/prd-eks-us-east-1/cluster]
aws_iam_role.node: Creation complete after 2s [id=prd-eks-node-role-us-east-1]
aws_iam_role_policy_attachment.node_eks_worker_node_policy: Creating...
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only: Creating...
aws_iam_role_policy_attachment.node_eks_cni_policy: Creating...
aws_iam_role_policy_attachment.cluster_eks_cluster_policy: Creation complete after 1s [id=prd-eks-cluster-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy]
aws_iam_role_policy_attachment.node_eks_cni_policy: Creation complete after 0s [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy]
aws_iam_role_policy_attachment.node_eks_worker_node_policy: Creation complete after 0s [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy]
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only: Creation complete after 0s [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly]
aws_kms_key.secrets: Still creating... [00m10s elapsed]
aws_kms_key.secrets: Creation complete after 11s [id=8ddad319-8607-4881-9098-4199e76641cc]
aws_kms_alias.secrets: Creating...
aws_eks_cluster.this: Creating...
aws_kms_alias.secrets: Creation complete after 1s [id=alias/prd-eks-secrets-us-east-1]
aws_eks_cluster.this: Still creating... [00m10s elapsed]
aws_eks_cluster.this: Still creating... [00m20s elapsed]
aws_eks_cluster.this: Still creating... [00m30s elapsed]
aws_eks_cluster.this: Still creating... [00m40s elapsed]
aws_eks_cluster.this: Still creating... [00m50s elapsed]
aws_eks_cluster.this: Still creating... [01m00s elapsed]
aws_eks_cluster.this: Still creating... [01m10s elapsed]
aws_eks_cluster.this: Still creating... [01m20s elapsed]
aws_eks_cluster.this: Still creating... [01m30s elapsed]
aws_eks_cluster.this: Still creating... [01m40s elapsed]
aws_eks_cluster.this: Still creating... [01m50s elapsed]
aws_eks_cluster.this: Still creating... [02m00s elapsed]
aws_eks_cluster.this: Still creating... [02m10s elapsed]
aws_eks_cluster.this: Still creating... [02m20s elapsed]
aws_eks_cluster.this: Still creating... [02m30s elapsed]
aws_eks_cluster.this: Still creating... [02m40s elapsed]
aws_eks_cluster.this: Still creating... [02m50s elapsed]
aws_eks_cluster.this: Still creating... [03m00s elapsed]
aws_eks_cluster.this: Still creating... [03m10s elapsed]
aws_eks_cluster.this: Still creating... [03m20s elapsed]
aws_eks_cluster.this: Still creating... [03m30s elapsed]
aws_eks_cluster.this: Still creating... [03m40s elapsed]
aws_eks_cluster.this: Still creating... [03m50s elapsed]
aws_eks_cluster.this: Still creating... [04m00s elapsed]
aws_eks_cluster.this: Still creating... [04m10s elapsed]
aws_eks_cluster.this: Still creating... [04m20s elapsed]
aws_eks_cluster.this: Still creating... [04m30s elapsed]
aws_eks_cluster.this: Still creating... [04m40s elapsed]
aws_eks_cluster.this: Still creating... [04m50s elapsed]
aws_eks_cluster.this: Still creating... [05m00s elapsed]
aws_eks_cluster.this: Still creating... [05m10s elapsed]
aws_eks_cluster.this: Still creating... [05m20s elapsed]
aws_eks_cluster.this: Still creating... [05m30s elapsed]
aws_eks_cluster.this: Still creating... [05m40s elapsed]
aws_eks_cluster.this: Still creating... [05m50s elapsed]
aws_eks_cluster.this: Still creating... [06m00s elapsed]
aws_eks_cluster.this: Still creating... [06m10s elapsed]
aws_eks_cluster.this: Still creating... [06m20s elapsed]
aws_eks_cluster.this: Still creating... [06m30s elapsed]
aws_eks_cluster.this: Still creating... [06m40s elapsed]
aws_eks_cluster.this: Still creating... [06m50s elapsed]
aws_eks_cluster.this: Still creating... [07m00s elapsed]
aws_eks_cluster.this: Still creating... [07m10s elapsed]
aws_eks_cluster.this: Still creating... [07m20s elapsed]
aws_eks_cluster.this: Still creating... [07m30s elapsed]
aws_eks_cluster.this: Still creating... [07m40s elapsed]
aws_eks_cluster.this: Still creating... [07m50s elapsed]
aws_eks_cluster.this: Still creating... [08m00s elapsed]
aws_eks_cluster.this: Still creating... [08m10s elapsed]
aws_eks_cluster.this: Still creating... [08m20s elapsed]
aws_eks_cluster.this: Still creating... [08m30s elapsed]
aws_eks_cluster.this: Still creating... [08m40s elapsed]
aws_eks_cluster.this: Still creating... [08m50s elapsed]
aws_eks_cluster.this: Still creating... [09m00s elapsed]
aws_eks_cluster.this: Still creating... [09m10s elapsed]
aws_eks_cluster.this: Still creating... [09m20s elapsed]
aws_eks_cluster.this: Still creating... [09m30s elapsed]
aws_eks_cluster.this: Still creating... [09m40s elapsed]
aws_eks_cluster.this: Still creating... [09m50s elapsed]
aws_eks_cluster.this: Still creating... [10m00s elapsed]
aws_eks_cluster.this: Still creating... [10m10s elapsed]
aws_eks_cluster.this: Creation complete after 10m16s [id=prd-eks-us-east-1]
aws_iam_openid_connect_provider.this: Creating...
aws_eks_node_group.this: Creating...
aws_iam_openid_connect_provider.this: Creation complete after 1s [id=arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/B5F5B691F6CA0254AEA5DB33C5B7189A]
aws_eks_node_group.this: Still creating... [00m10s elapsed]
aws_eks_node_group.this: Still creating... [00m20s elapsed]
aws_eks_node_group.this: Still creating... [00m30s elapsed]
aws_eks_node_group.this: Still creating... [00m40s elapsed]
aws_eks_node_group.this: Still creating... [00m50s elapsed]
aws_eks_node_group.this: Still creating... [01m00s elapsed]
aws_eks_node_group.this: Still creating... [01m10s elapsed]
aws_eks_node_group.this: Creation complete after 1m18s [id=prd-eks-us-east-1:prd-eks-ng-us-east-1]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

eks_cluster_arn = "arn:aws:eks:us-east-1:659942169599:cluster/prd-eks-us-east-1"
eks_cluster_certificate_authority_data = <sensitive>
eks_cluster_endpoint = "https://B5F5B691F6CA0254AEA5DB33C5B7189A.yl4.us-east-1.eks.amazonaws.com"
eks_cluster_iam_role_arn = "arn:aws:iam::659942169599:role/prd-eks-cluster-role-us-east-1"
eks_cluster_id = "prd-eks-us-east-1"
eks_cluster_log_group_name = "/aws/eks/prd-eks-us-east-1/cluster"
eks_cluster_oidc_issuer_url = "https://oidc.eks.us-east-1.amazonaws.com/id/B5F5B691F6CA0254AEA5DB33C5B7189A"
eks_cluster_security_group_id = "sg-08a127515c691add0"
eks_node_group_id = "prd-eks-us-east-1:prd-eks-ng-us-east-1"
eks_node_group_status = "ACTIVE"
eks_node_iam_role_arn = "arn:aws:iam::659942169599:role/prd-eks-node-role-us-east-1"
eks_oidc_provider_arn = "arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/B5F5B691F6CA0254AEA5DB33C5B7189A"
eks_secrets_kms_key_arn = "arn:aws:kms:us-east-1:659942169599:key/8ddad319-8607-4881-9098-4199e76641cc"
networking_private_subnets_ids = tolist([
  "subnet-0ca8fdd7f7235d180",
  "subnet-0bad2fdc9d281c06a",
])
networking_public_subnets_ids = tolist([
  "subnet-0371b3b114f3a204b",
  "subnet-04d5956cb61b4689d",
])
networking_vpc_id = "vpc-0882c8ebd4a1d9e97"
```

## Outputs

```json
{
  "eks_cluster_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:eks:us-east-1:659942169599:cluster/prd-eks-us-east-1"
  },
  "eks_cluster_certificate_authority_data": {
    "sensitive": true,
    "type": "string",
    "value": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURNakNDQWhxZ0F3SUJBZ0lSQVBENnFtdGNrWUdxMW4vUzN4Z1dTUmN3RFFZSktvWklodmNOQVFFTEJRQXcKSnpFUU1BNEdBMVVFQ2hNSFFWZFRJRVZMVXpFVE1CRUdBMVVFQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TmpBNQpNakV4TkRBeE5EZGFGdzB6TVRBNU1qQXhOREF4TkRkYU1DY3hFREFPQmdOVkJBb1RCMEZYVXlCRlMxTXhFekFSCkJnTlZCQU1UQ210MVltVnlibVYwWlhNd2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFS0FvSUIKQVFEUlMyWDg0UmdvWHJmVUFwcFoxbjRMaFEwTEJkQ0ZPMjY4R1JYUlpFSVNJRlk4LzNzcUlGbGJ2cUlzMzZkUgpGUmMxcUxKWmRxTXZwVGhBek9yeDA4Y2FKNi84NTY1cmkzZ016VkxFN2xESTVFajk5eGlyaURNcXJWZ3U1RG9ZCk5iSHhLTFV2U01uNzhUeHo1MzhYQUo3WFhYZVpNUDZiQU5zTkpXdzkyOXNUVEk0d2JRL0ZNVUdJYmJlT3BxL0gKaThHNVpwQkRXU3NNZU1RUFBqM2V2Mm1WanBkY3RhNmNpcEZLdUVsaWoyVlRtWlExenpwOVM4RjB2N2RidUU0WgpRSHFIcEhOTENTbzdXWTRMVkVBV2xjWVFjVWxaYm5BTWp3elRuZmxjRmFZSHpuUkVNeFZCekVmcHcrdk1QSlBmClZUWmdodXVQWThmdWl2TEx2akFISDJCRkFnTUJBQUdqV1RCWE1BNEdBMVVkRHdFQi93UUVBd0lDcERBUEJnTlYKSFJNQkFmOEVCVEFEQVFIL01CMEdBMVVkRGdRV0JCVDR4d0Z2a1hoVWUwNXViSnB5ZElpS1JLeThmVEFWQmdOVgpIUkVFRGpBTWdncHJkV0psY201bGRHVnpNQTBHQ1NxR1NJYjNEUUVCQ3dVQUE0SUJBUUJQNzFIRHk4M2hkSjBuCkxKS2xJL3NtUFpIa2dheGdWTkVNd2lrZEhZeXpFRmF1aE1WVkM3aWlKRVBpNzM4MU1lcUpFWlU5azJqVmdURU0KMnVGakdzMHpxdVJvOUxXbDVBeTZ1WUtWSEozb0hCUFRjckN6K09hQUxWLzJqeDQwVjBqU003cFhvVkNTVnBSTgpKdkZMR0Q1aFNLZmtzNzE1R05pejFYVjg4WmtFTUZCRUpVQzZTTlZxU1k0NHNSM204MzBnSFJ0QWk5S1RTY3I3Clp2QVNPUWN4Y2tsUDI2YTFGRGdQTXRDS2Y1TjN6TDFhTFpPTE5hdFlRQU45K25OMXdYVHlSSzYyM1JKeE5JMzkKVlZIbTdGa3pnalIvRGJlbmE2bUVMajBqNVZjM0xSUHBzalBMZUQrS1V6K3JPNVRweTJlRVVVdTlTZWppU05VeAp6UWpNY2U3ZQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
  },
  "eks_cluster_endpoint": {
    "sensitive": false,
    "type": "string",
    "value": "https://B5F5B691F6CA0254AEA5DB33C5B7189A.yl4.us-east-1.eks.amazonaws.com"
  },
  "eks_cluster_iam_role_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:iam::659942169599:role/prd-eks-cluster-role-us-east-1"
  },
  "eks_cluster_id": {
    "sensitive": false,
    "type": "string",
    "value": "prd-eks-us-east-1"
  },
  "eks_cluster_log_group_name": {
    "sensitive": false,
    "type": "string",
    "value": "/aws/eks/prd-eks-us-east-1/cluster"
  },
  "eks_cluster_oidc_issuer_url": {
    "sensitive": false,
    "type": "string",
    "value": "https://oidc.eks.us-east-1.amazonaws.com/id/B5F5B691F6CA0254AEA5DB33C5B7189A"
  },
  "eks_cluster_security_group_id": {
    "sensitive": false,
    "type": "string",
    "value": "sg-08a127515c691add0"
  },
  "eks_node_group_id": {
    "sensitive": false,
    "type": "string",
    "value": "prd-eks-us-east-1:prd-eks-ng-us-east-1"
  },
  "eks_node_group_status": {
    "sensitive": false,
    "type": "string",
    "value": "ACTIVE"
  },
  "eks_node_iam_role_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:iam::659942169599:role/prd-eks-node-role-us-east-1"
  },
  "eks_oidc_provider_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/B5F5B691F6CA0254AEA5DB33C5B7189A"
  },
  "eks_secrets_kms_key_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:kms:us-east-1:659942169599:key/8ddad319-8607-4881-9098-4199e76641cc"
  },
  "networking_private_subnets_ids": {
    "sensitive": false,
    "type": [
      "list",
      "string"
    ],
    "value": [
      "subnet-0ca8fdd7f7235d180",
      "subnet-0bad2fdc9d281c06a"
    ]
  },
  "networking_public_subnets_ids": {
    "sensitive": false,
    "type": [
      "list",
      "string"
    ],
    "value": [
      "subnet-0371b3b114f3a204b",
      "subnet-04d5956cb61b4689d"
    ]
  },
  "networking_vpc_id": {
    "sensitive": false,
    "type": "string",
    "value": "vpc-0882c8ebd4a1d9e97"
  }
}
```

## Recursos no state

```
data.aws_caller_identity.current
data.aws_iam_policy_document.cluster_assume_role
data.aws_iam_policy_document.node_assume_role
data.aws_subnets.private
data.aws_subnets.public
data.aws_vpc.networking
aws_cloudwatch_log_group.cluster
aws_eks_cluster.this
aws_eks_node_group.this
aws_iam_openid_connect_provider.this
aws_iam_role.cluster
aws_iam_role.node
aws_iam_role_policy_attachment.cluster_eks_cluster_policy
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only
aws_iam_role_policy_attachment.node_eks_cni_policy
aws_iam_role_policy_attachment.node_eks_worker_node_policy
aws_kms_alias.secrets
aws_kms_key.secrets
```
