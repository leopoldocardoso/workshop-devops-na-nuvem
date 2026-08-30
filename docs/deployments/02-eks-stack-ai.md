# Deployment: 02-eks-stack-ai

> Gerado automaticamente por `.claude/skills/terraform-deploy/deploy.sh`
> apos `terraform apply -auto-approve`. Nao editar manualmente —
> este arquivo e sobrescrito no proximo deploy desta stack.

- **Stack:** `02-eks-stack-ai`
- **Data do apply (UTC):** 2026-08-30T15:55:34Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que aplicou:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do apply

```
aws_kms_key.secrets: Creating...
aws_iam_role.cluster: Creating...
aws_cloudwatch_log_group.cluster: Creating...
aws_iam_role.node: Creating...
aws_cloudwatch_log_group.cluster: Creation complete after 1s [id=/aws/eks/prd-eks-us-east-1/cluster]
aws_iam_role.cluster: Creation complete after 1s [id=prd-eks-cluster-role-us-east-1]
aws_iam_role.node: Creation complete after 1s [id=prd-eks-node-role-us-east-1]
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only: Creating...
aws_iam_role_policy_attachment.node_eks_worker_node_policy: Creating...
aws_iam_role_policy_attachment.cluster_eks_cluster_policy: Creating...
aws_iam_role_policy_attachment.node_eks_cni_policy: Creating...
aws_iam_role_policy_attachment.node_eks_cni_policy: Creation complete after 1s [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy]
aws_iam_role_policy_attachment.node_eks_worker_node_policy: Creation complete after 1s [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy]
aws_iam_role_policy_attachment.cluster_eks_cluster_policy: Creation complete after 1s [id=prd-eks-cluster-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy]
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only: Creation complete after 1s [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly]
aws_kms_key.secrets: Still creating... [00m10s elapsed]
aws_kms_key.secrets: Creation complete after 11s [id=8cc07429-e4e2-4026-ba03-ea220a22e95f]
aws_kms_alias.secrets: Creating...
aws_eks_cluster.this: Creating...
aws_kms_alias.secrets: Creation complete after 0s [id=alias/prd-eks-secrets-us-east-1]
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
aws_eks_cluster.this: Creation complete after 10m4s [id=prd-eks-us-east-1]
aws_iam_openid_connect_provider.this: Creating...
aws_eks_node_group.this: Creating...
aws_iam_openid_connect_provider.this: Creation complete after 2s [id=arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775]
aws_eks_node_group.this: Still creating... [00m10s elapsed]
aws_eks_node_group.this: Still creating... [00m20s elapsed]
aws_eks_node_group.this: Still creating... [00m30s elapsed]
aws_eks_node_group.this: Still creating... [00m40s elapsed]
aws_eks_node_group.this: Still creating... [00m50s elapsed]
aws_eks_node_group.this: Still creating... [01m00s elapsed]
aws_eks_node_group.this: Still creating... [01m10s elapsed]
aws_eks_node_group.this: Still creating... [01m20s elapsed]
aws_eks_node_group.this: Still creating... [01m30s elapsed]
aws_eks_node_group.this: Still creating... [01m40s elapsed]
aws_eks_node_group.this: Creation complete after 1m49s [id=prd-eks-us-east-1:prd-eks-ng-us-east-1]

Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

eks_cluster_arn = "arn:aws:eks:us-east-1:659942169599:cluster/prd-eks-us-east-1"
eks_cluster_certificate_authority_data = <sensitive>
eks_cluster_endpoint = "https://3D73689BCA1D30C3D7BCBEACA91F7775.gr7.us-east-1.eks.amazonaws.com"
eks_cluster_iam_role_arn = "arn:aws:iam::659942169599:role/prd-eks-cluster-role-us-east-1"
eks_cluster_id = "prd-eks-us-east-1"
eks_cluster_log_group_name = "/aws/eks/prd-eks-us-east-1/cluster"
eks_cluster_oidc_issuer_url = "https://oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775"
eks_cluster_security_group_id = "sg-01a1a114f6db703ca"
eks_node_group_id = "prd-eks-us-east-1:prd-eks-ng-us-east-1"
eks_node_group_status = "ACTIVE"
eks_node_iam_role_arn = "arn:aws:iam::659942169599:role/prd-eks-node-role-us-east-1"
eks_oidc_provider_arn = "arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775"
eks_secrets_kms_key_arn = "arn:aws:kms:us-east-1:659942169599:key/8cc07429-e4e2-4026-ba03-ea220a22e95f"
networking_private_subnets_ids = tolist([
  "subnet-0c6fcdfd9dc8b0967",
  "subnet-0f9f6bd9df3aab8bf",
])
networking_public_subnets_ids = tolist([
  "subnet-0ec73e30e5d4a81b3",
  "subnet-059b33c4972f1f3ca",
])
networking_vpc_id = "vpc-0b5c9a35a431fd223"
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
    "value": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUREVENDQWZXZ0F3SUJBZ0lRWktPNGszU05SMFY4NDZqYXFHNEV4VEFOQmdrcWhraUc5dzBCQVFzRkFEQVYKTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1CNFhEVEkyTURnek1ERTFORE0xTWxvWERUTXhNRGd5T1RFMQpORE0xTWxvd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekNDQVNJd0RRWUpLb1pJaHZjTkFRRUJCUUFECmdnRVBBRENDQVFvQ2dnRUJBTlhDN2U0UktONnFCcFhvTFo5MWxkZVVqdHZ1L1VRSXRvRkJyTzRreE9xSlNEdlgKcm5DV0hZdzd1TmRFQlBBdEhUMzF5QlBESzNlSTA4emVvUmhvTW9ENmEzQUlYeG1qQVlqczBaWWhUTUV2MFBkQwp0a0JFQVhyNkd3MGNhc055RW5IekxiTWJCWC9MVjB1L1IwQXV3UG5zbkVYcTlBdk9RQy9TazRPd0Z2RERqNjdiCi9kNkpKUGZ5T2N5ZTVzVWVDQnQ2Vkg4cmdMajZtd3FtUXdvdzkyVlJEMFp4SGRzaUE1dWRYU0pGRW1oYkRWWjEKWnFvTy84SWZRWjFhMHk3bWFtKzc4Z1ppOUlycHNOdGRUMjJBdFg2ZTcyTHlRZHVaQWh6RDJVTnBzTGR6b2tGMgpqWlJmV2ZKRG5JaFNQOFdnTjNabWpNbEszVmJwOHFqa0lOREtMb01DQXdFQUFhTlpNRmN3RGdZRFZSMFBBUUgvCkJBUURBZ0trTUE4R0ExVWRFd0VCL3dRRk1BTUJBZjh3SFFZRFZSME9CQllFRkJaRFBxcVJJUU9yS2xFWDVqY0MKYmtDS0FEUjdNQlVHQTFVZEVRUU9NQXlDQ210MVltVnlibVYwWlhNd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQgpBS3ZicEFoK2EwbVg0d3ZOaFZYMlR0Y2hpK0tBb25Ra09ZcDRJb09DRDlMMzRVb094WVI2VUE5L0VldCtEdmtzClJ0UGZmT1FxbXZFYUdDWjY0NitUR1RmZFhYaVp5Sys5L2xIRm9Ldmg2RjVmbW92b1JtY0NCV1c1VG1RYTVEQW4KRTJJRy9iM2h3NHRzUFlzdVc4MFNIeGNwQWpKOHJBVUNQZnNRYWFXVmNZemtQVFRiOXMyOWxPbmxBTC9ublZWTwo0dXpVK1I1a2M2aVRPSHhVdWRqYjVkSjdiRFpEcld6Y2hkTU45cGR5WWtzS0pESU54SFMzVFVrYkpOQmNEdjR6CnhvT0JHVkRWQmNWeHRJNkp0RzN0NHU3emo2VDBRMi9BbTJJdmlpaEV0cDZ2M0c5WkpybE9yWHo5ZWxnZjhidkQKVjRqVUtuODRPaFNWL2VjMmFqM2x5Nms9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
  },
  "eks_cluster_endpoint": {
    "sensitive": false,
    "type": "string",
    "value": "https://3D73689BCA1D30C3D7BCBEACA91F7775.gr7.us-east-1.eks.amazonaws.com"
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
    "value": "https://oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775"
  },
  "eks_cluster_security_group_id": {
    "sensitive": false,
    "type": "string",
    "value": "sg-01a1a114f6db703ca"
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
    "value": "arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775"
  },
  "eks_secrets_kms_key_arn": {
    "sensitive": false,
    "type": "string",
    "value": "arn:aws:kms:us-east-1:659942169599:key/8cc07429-e4e2-4026-ba03-ea220a22e95f"
  },
  "networking_private_subnets_ids": {
    "sensitive": false,
    "type": [
      "list",
      "string"
    ],
    "value": [
      "subnet-0c6fcdfd9dc8b0967",
      "subnet-0f9f6bd9df3aab8bf"
    ]
  },
  "networking_public_subnets_ids": {
    "sensitive": false,
    "type": [
      "list",
      "string"
    ],
    "value": [
      "subnet-0ec73e30e5d4a81b3",
      "subnet-059b33c4972f1f3ca"
    ]
  },
  "networking_vpc_id": {
    "sensitive": false,
    "type": "string",
    "value": "vpc-0b5c9a35a431fd223"
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
