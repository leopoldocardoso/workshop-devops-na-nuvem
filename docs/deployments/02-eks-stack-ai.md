# Deployment: 02-eks-stack-ai — STACK DESTRUIDA

> Registrado automaticamente por `.claude/skills/terraform-destroy/destroy.sh`
> apos `terraform destroy -auto-approve`. Nao editar manualmente.

- **Stack:** `02-eks-stack-ai`
- **Data do destroy (UTC):** 2026-08-30T16:42:12Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que destruiu:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do destroy

```
data.aws_iam_policy_document.node_assume_role: Reading...
data.aws_vpc.networking: Reading...
data.aws_iam_policy_document.cluster_assume_role: Reading...
data.aws_caller_identity.current: Reading...
aws_cloudwatch_log_group.cluster: Refreshing state... [id=/aws/eks/prd-eks-us-east-1/cluster]
aws_kms_key.secrets: Refreshing state... [id=8cc07429-e4e2-4026-ba03-ea220a22e95f]
data.aws_iam_policy_document.cluster_assume_role: Read complete after 0s [id=1029077455]
data.aws_iam_policy_document.node_assume_role: Read complete after 0s [id=2851119427]
aws_iam_role.cluster: Refreshing state... [id=prd-eks-cluster-role-us-east-1]
aws_iam_role.node: Refreshing state... [id=prd-eks-node-role-us-east-1]
data.aws_caller_identity.current: Read complete after 0s [id=659942169599]
aws_kms_alias.secrets: Refreshing state... [id=alias/prd-eks-secrets-us-east-1]
aws_iam_role_policy_attachment.cluster_eks_cluster_policy: Refreshing state... [id=prd-eks-cluster-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy]
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only: Refreshing state... [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly]
aws_iam_role_policy_attachment.node_eks_cni_policy: Refreshing state... [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy]
aws_iam_role_policy_attachment.node_eks_worker_node_policy: Refreshing state... [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy]
data.aws_vpc.networking: Read complete after 1s [id=vpc-0b5c9a35a431fd223]
data.aws_subnets.public: Reading...
data.aws_subnets.private: Reading...
data.aws_subnets.public: Read complete after 0s [id=us-east-1]
data.aws_subnets.private: Read complete after 1s [id=us-east-1]
aws_eks_cluster.this: Refreshing state... [id=prd-eks-us-east-1]
aws_iam_openid_connect_provider.this: Refreshing state... [id=arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775]
aws_eks_node_group.this: Refreshing state... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_cloudwatch_log_group.cluster will be destroyed
  - resource "aws_cloudwatch_log_group" "cluster" {
      - arn                         = "arn:aws:logs:us-east-1:659942169599:log-group:/aws/eks/prd-eks-us-east-1/cluster" -> null
      - deletion_protection_enabled = false -> null
      - id                          = "/aws/eks/prd-eks-us-east-1/cluster" -> null
      - log_group_class             = "STANDARD" -> null
      - name                        = "/aws/eks/prd-eks-us-east-1/cluster" -> null
      - region                      = "us-east-1" -> null
      - retention_in_days           = 90 -> null
      - skip_destroy                = false -> null
      - tags                        = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "/aws/eks/prd-eks-us-east-1/cluster"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - tags_all                    = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "/aws/eks/prd-eks-us-east-1/cluster"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
        # (2 unchanged attributes hidden)
    }

  # aws_eks_cluster.this will be destroyed
  - resource "aws_eks_cluster" "this" {
      - arn                           = "arn:aws:eks:us-east-1:659942169599:cluster/prd-eks-us-east-1" -> null
      - bootstrap_self_managed_addons = true -> null
      - certificate_authority         = [
          - {
              - data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUREVENDQWZXZ0F3SUJBZ0lRWktPNGszU05SMFY4NDZqYXFHNEV4VEFOQmdrcWhraUc5dzBCQVFzRkFEQVYKTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1CNFhEVEkyTURnek1ERTFORE0xTWxvWERUTXhNRGd5T1RFMQpORE0xTWxvd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekNDQVNJd0RRWUpLb1pJaHZjTkFRRUJCUUFECmdnRVBBRENDQVFvQ2dnRUJBTlhDN2U0UktONnFCcFhvTFo5MWxkZVVqdHZ1L1VRSXRvRkJyTzRreE9xSlNEdlgKcm5DV0hZdzd1TmRFQlBBdEhUMzF5QlBESzNlSTA4emVvUmhvTW9ENmEzQUlYeG1qQVlqczBaWWhUTUV2MFBkQwp0a0JFQVhyNkd3MGNhc055RW5IekxiTWJCWC9MVjB1L1IwQXV3UG5zbkVYcTlBdk9RQy9TazRPd0Z2RERqNjdiCi9kNkpKUGZ5T2N5ZTVzVWVDQnQ2Vkg4cmdMajZtd3FtUXdvdzkyVlJEMFp4SGRzaUE1dWRYU0pGRW1oYkRWWjEKWnFvTy84SWZRWjFhMHk3bWFtKzc4Z1ppOUlycHNOdGRUMjJBdFg2ZTcyTHlRZHVaQWh6RDJVTnBzTGR6b2tGMgpqWlJmV2ZKRG5JaFNQOFdnTjNabWpNbEszVmJwOHFqa0lOREtMb01DQXdFQUFhTlpNRmN3RGdZRFZSMFBBUUgvCkJBUURBZ0trTUE4R0ExVWRFd0VCL3dRRk1BTUJBZjh3SFFZRFZSME9CQllFRkJaRFBxcVJJUU9yS2xFWDVqY0MKYmtDS0FEUjdNQlVHQTFVZEVRUU9NQXlDQ210MVltVnlibVYwWlhNd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQgpBS3ZicEFoK2EwbVg0d3ZOaFZYMlR0Y2hpK0tBb25Ra09ZcDRJb09DRDlMMzRVb094WVI2VUE5L0VldCtEdmtzClJ0UGZmT1FxbXZFYUdDWjY0NitUR1RmZFhYaVp5Sys5L2xIRm9Ldmg2RjVmbW92b1JtY0NCV1c1VG1RYTVEQW4KRTJJRy9iM2h3NHRzUFlzdVc4MFNIeGNwQWpKOHJBVUNQZnNRYWFXVmNZemtQVFRiOXMyOWxPbmxBTC9ublZWTwo0dXpVK1I1a2M2aVRPSHhVdWRqYjVkSjdiRFpEcld6Y2hkTU45cGR5WWtzS0pESU54SFMzVFVrYkpOQmNEdjR6CnhvT0JHVkRWQmNWeHRJNkp0RzN0NHU3emo2VDBRMi9BbTJJdmlpaEV0cDZ2M0c5WkpybE9yWHo5ZWxnZjhidkQKVjRqVUtuODRPaFNWL2VjMmFqM2x5Nms9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
            },
        ] -> null
      - created_at                    = "2026-08-30T15:43:43Z" -> null
      - deletion_protection           = false -> null
      - enabled_cluster_log_types     = [
          - "api",
          - "audit",
          - "authenticator",
          - "controllerManager",
          - "scheduler",
        ] -> null
      - endpoint                      = "https://3D73689BCA1D30C3D7BCBEACA91F7775.gr7.us-east-1.eks.amazonaws.com" -> null
      - id                            = "prd-eks-us-east-1" -> null
      - identity                      = [
          - {
              - oidc = [
                  - {
                      - issuer = "https://oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775"
                    },
                ]
            },
        ] -> null
      - name                          = "prd-eks-us-east-1" -> null
      - platform_version              = "eks.31" -> null
      - region                        = "us-east-1" -> null
      - role_arn                      = "arn:aws:iam::659942169599:role/prd-eks-cluster-role-us-east-1" -> null
      - status                        = "ACTIVE" -> null
      - tags                          = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - tags_all                      = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - version                       = "1.34" -> null

      - access_config {
          - authentication_mode                         = "API" -> null
          - bootstrap_cluster_creator_admin_permissions = true -> null
        }

      - compute_config {
          - enabled       = false -> null
          - node_pools    = [] -> null
            # (1 unchanged attribute hidden)
        }

      - control_plane_scaling_config {
          - tier = "standard" -> null
        }

      - encryption_config {
          - resources = [
              - "secrets",
            ] -> null

          - provider {
              - key_arn = "arn:aws:kms:us-east-1:659942169599:key/8cc07429-e4e2-4026-ba03-ea220a22e95f" -> null
            }
        }

      - kube_api_server_config {
          - event_ttl = "60m" -> null

          - service_node_port_range {
              - max_port = 32767 -> null
              - min_port = 30000 -> null
            }
        }

      - kube_controller_manager_config {
          - horizontal_pod_autoscaler_controller_config {
              - horizontal_pod_autoscaler_sync_period = "15s" -> null
            }
        }

      - kube_scheduler_config {
          - node_resources_fit {
              - scoring_strategy {
                  - type = "LeastAllocated" -> null

                  - resource {
                      - name   = "cpu" -> null
                      - weight = 1 -> null
                    }
                  - resource {
                      - name   = "memory" -> null
                      - weight = 1 -> null
                    }
                }
            }
        }

      - kubernetes_network_config {
          - ip_family         = "ipv4" -> null
          - service_ipv4_cidr = "172.20.0.0/16" -> null
            # (1 unchanged attribute hidden)

          - elastic_load_balancing {
              - enabled = false -> null
            }
        }

      - storage_config {
          - block_storage {
              - enabled = false -> null
            }
        }

      - upgrade_policy {
          - support_type = "EXTENDED" -> null
        }

      - vpc_config {
          - cluster_security_group_id = "sg-01a1a114f6db703ca" -> null
          - control_plane_egress_mode = "AWS_MANAGED" -> null
          - endpoint_private_access   = true -> null
          - endpoint_public_access    = true -> null
          - public_access_cidrs       = [
              - "177.37.171.248/32",
            ] -> null
          - security_group_ids        = [] -> null
          - subnet_ids                = [
              - "subnet-059b33c4972f1f3ca",
              - "subnet-0c6fcdfd9dc8b0967",
              - "subnet-0ec73e30e5d4a81b3",
              - "subnet-0f9f6bd9df3aab8bf",
            ] -> null
          - vpc_id                    = "vpc-0b5c9a35a431fd223" -> null
        }
    }

  # aws_eks_node_group.this will be destroyed
  - resource "aws_eks_node_group" "this" {
      - ami_type               = "AL2023_x86_64_STANDARD" -> null
      - arn                    = "arn:aws:eks:us-east-1:659942169599:nodegroup/prd-eks-us-east-1/prd-eks-ng-us-east-1/28d029b0-3aa9-c1ac-60e4-d5dc597b1378" -> null
      - capacity_type          = "ON_DEMAND" -> null
      - cluster_name           = "prd-eks-us-east-1" -> null
      - disk_size              = 20 -> null
      - id                     = "prd-eks-us-east-1:prd-eks-ng-us-east-1" -> null
      - instance_types         = [
          - "t3.medium",
        ] -> null
      - labels                 = {} -> null
      - node_group_name        = "prd-eks-ng-us-east-1" -> null
      - node_role_arn          = "arn:aws:iam::659942169599:role/prd-eks-node-role-us-east-1" -> null
      - region                 = "us-east-1" -> null
      - release_version        = "1.34.10-20260827" -> null
      - resources              = [
          - {
              - autoscaling_groups              = [
                  - {
                      - name = "eks-prd-eks-ng-us-east-1-28d029b0-3aa9-c1ac-60e4-d5dc597b1378"
                    },
                ]
                # (1 unchanged attribute hidden)
            },
        ] -> null
      - status                 = "ACTIVE" -> null
      - subnet_ids             = [
          - "subnet-0c6fcdfd9dc8b0967",
          - "subnet-0f9f6bd9df3aab8bf",
        ] -> null
      - tags                   = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-ng-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - tags_all               = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-ng-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - version                = "1.34" -> null
        # (1 unchanged attribute hidden)

      - node_repair_config {
          - enabled                                 = true -> null
          - max_parallel_nodes_repaired_count       = 0 -> null
          - max_parallel_nodes_repaired_percentage  = 0 -> null
          - max_unhealthy_node_threshold_count      = 0 -> null
          - max_unhealthy_node_threshold_percentage = 0 -> null
        }

      - scaling_config {
          - desired_size = 2 -> null
          - max_size     = 3 -> null
          - min_size     = 2 -> null
        }

      - update_config {
          - max_unavailable            = 1 -> null
          - max_unavailable_percentage = 0 -> null
            # (1 unchanged attribute hidden)
        }
    }

  # aws_iam_openid_connect_provider.this will be destroyed
  - resource "aws_iam_openid_connect_provider" "this" {
      - arn             = "arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775" -> null
      - client_id_list  = [
          - "sts.amazonaws.com",
        ] -> null
      - id              = "arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775" -> null
      - tags            = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-oidc-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - tags_all        = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-oidc-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - thumbprint_list = [
          - "06b25927c42a721631c1efd9431e648fa62e1e39",
        ] -> null
      - url             = "oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775" -> null
    }

  # aws_iam_role.cluster will be destroyed
  - resource "aws_iam_role" "cluster" {
      - arn                   = "arn:aws:iam::659942169599:role/prd-eks-cluster-role-us-east-1" -> null
      - assume_role_policy    = jsonencode(
            {
              - Statement = [
                  - {
                      - Action    = [
                          - "sts:TagSession",
                          - "sts:AssumeRole",
                        ]
                      - Effect    = "Allow"
                      - Principal = {
                          - Service = "eks.amazonaws.com"
                        }
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> null
      - create_date           = "2026-08-30T15:43:30Z" -> null
      - force_detach_policies = false -> null
      - id                    = "prd-eks-cluster-role-us-east-1" -> null
      - managed_policy_arns   = [
          - "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
        ] -> null
      - max_session_duration  = 3600 -> null
      - name                  = "prd-eks-cluster-role-us-east-1" -> null
      - path                  = "/" -> null
      - tags                  = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-cluster-role-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - tags_all              = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-cluster-role-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - unique_id             = "AROAZTJ46LP7Q22YTYQCL" -> null
        # (3 unchanged attributes hidden)
    }

  # aws_iam_role.node will be destroyed
  - resource "aws_iam_role" "node" {
      - arn                   = "arn:aws:iam::659942169599:role/prd-eks-node-role-us-east-1" -> null
      - assume_role_policy    = jsonencode(
            {
              - Statement = [
                  - {
                      - Action    = "sts:AssumeRole"
                      - Effect    = "Allow"
                      - Principal = {
                          - Service = "ec2.amazonaws.com"
                        }
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> null
      - create_date           = "2026-08-30T15:43:30Z" -> null
      - force_detach_policies = false -> null
      - id                    = "prd-eks-node-role-us-east-1" -> null
      - managed_policy_arns   = [
          - "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
          - "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
          - "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        ] -> null
      - max_session_duration  = 3600 -> null
      - name                  = "prd-eks-node-role-us-east-1" -> null
      - path                  = "/" -> null
      - tags                  = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-node-role-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - tags_all              = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-node-role-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - unique_id             = "AROAZTJ46LP725FSGMMVT" -> null
        # (3 unchanged attributes hidden)
    }

  # aws_iam_role_policy_attachment.cluster_eks_cluster_policy will be destroyed
  - resource "aws_iam_role_policy_attachment" "cluster_eks_cluster_policy" {
      - id         = "prd-eks-cluster-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" -> null
      - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" -> null
      - role       = "prd-eks-cluster-role-us-east-1" -> null
    }

  # aws_iam_role_policy_attachment.node_ec2_container_registry_read_only will be destroyed
  - resource "aws_iam_role_policy_attachment" "node_ec2_container_registry_read_only" {
      - id         = "prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" -> null
      - policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" -> null
      - role       = "prd-eks-node-role-us-east-1" -> null
    }

  # aws_iam_role_policy_attachment.node_eks_cni_policy will be destroyed
  - resource "aws_iam_role_policy_attachment" "node_eks_cni_policy" {
      - id         = "prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" -> null
      - policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" -> null
      - role       = "prd-eks-node-role-us-east-1" -> null
    }

  # aws_iam_role_policy_attachment.node_eks_worker_node_policy will be destroyed
  - resource "aws_iam_role_policy_attachment" "node_eks_worker_node_policy" {
      - id         = "prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" -> null
      - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" -> null
      - role       = "prd-eks-node-role-us-east-1" -> null
    }

  # aws_kms_alias.secrets will be destroyed
  - resource "aws_kms_alias" "secrets" {
      - arn            = "arn:aws:kms:us-east-1:659942169599:alias/prd-eks-secrets-us-east-1" -> null
      - id             = "alias/prd-eks-secrets-us-east-1" -> null
      - name           = "alias/prd-eks-secrets-us-east-1" -> null
      - region         = "us-east-1" -> null
      - target_key_arn = "arn:aws:kms:us-east-1:659942169599:key/8cc07429-e4e2-4026-ba03-ea220a22e95f" -> null
      - target_key_id  = "8cc07429-e4e2-4026-ba03-ea220a22e95f" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_kms_key.secrets will be destroyed
  - resource "aws_kms_key" "secrets" {
      - arn                                = "arn:aws:kms:us-east-1:659942169599:key/8cc07429-e4e2-4026-ba03-ea220a22e95f" -> null
      - bypass_policy_lockout_safety_check = false -> null
      - customer_master_key_spec           = "SYMMETRIC_DEFAULT" -> null
      - deletion_window_in_days            = 30 -> null
      - description                        = "CMK dedicada para envelope encryption de Secrets do cluster EKS prd-eks-us-east-1 (ADR-0003 Secao 4/D3)." -> null
      - enable_key_rotation                = true -> null
      - id                                 = "8cc07429-e4e2-4026-ba03-ea220a22e95f" -> null
      - is_enabled                         = true -> null
      - key_id                             = "8cc07429-e4e2-4026-ba03-ea220a22e95f" -> null
      - key_usage                          = "ENCRYPT_DECRYPT" -> null
      - multi_region                       = false -> null
      - policy                             = jsonencode(
            {
              - Id        = "key-default-1"
              - Statement = [
                  - {
                      - Action    = "kms:*"
                      - Effect    = "Allow"
                      - Principal = {
                          - AWS = "arn:aws:iam::659942169599:root"
                        }
                      - Resource  = "*"
                      - Sid       = "Enable IAM User Permissions"
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> null
      - region                             = "us-east-1" -> null
      - rotation_period_in_days            = 365 -> null
      - tags                               = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-secrets-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
      - tags_all                           = {
          - "CostCenter"         = "worshop-devops-na-nuvem"
          - "DataClassification" = "confidential"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-eks-secrets-us-east-1"
          - "Owner"              = "Leopoldo Peixoto Cardoso"
          - "Project"            = "eks"
          - "StackName"          = "02-eks-stack-ai"
        } -> null
        # (2 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 12 to destroy.

Changes to Outputs:
  - eks_cluster_arn                        = "arn:aws:eks:us-east-1:659942169599:cluster/prd-eks-us-east-1" -> null
  - eks_cluster_certificate_authority_data = (sensitive value) -> null
  - eks_cluster_endpoint                   = "https://3D73689BCA1D30C3D7BCBEACA91F7775.gr7.us-east-1.eks.amazonaws.com" -> null
  - eks_cluster_iam_role_arn               = "arn:aws:iam::659942169599:role/prd-eks-cluster-role-us-east-1" -> null
  - eks_cluster_id                         = "prd-eks-us-east-1" -> null
  - eks_cluster_log_group_name             = "/aws/eks/prd-eks-us-east-1/cluster" -> null
  - eks_cluster_oidc_issuer_url            = "https://oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775" -> null
  - eks_cluster_security_group_id          = "sg-01a1a114f6db703ca" -> null
  - eks_node_group_id                      = "prd-eks-us-east-1:prd-eks-ng-us-east-1" -> null
  - eks_node_group_status                  = "ACTIVE" -> null
  - eks_node_iam_role_arn                  = "arn:aws:iam::659942169599:role/prd-eks-node-role-us-east-1" -> null
  - eks_oidc_provider_arn                  = "arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775" -> null
  - eks_secrets_kms_key_arn                = "arn:aws:kms:us-east-1:659942169599:key/8cc07429-e4e2-4026-ba03-ea220a22e95f" -> null
  - networking_private_subnets_ids         = [
      - "subnet-0c6fcdfd9dc8b0967",
      - "subnet-0f9f6bd9df3aab8bf",
    ] -> null
  - networking_public_subnets_ids          = [
      - "subnet-0ec73e30e5d4a81b3",
      - "subnet-059b33c4972f1f3ca",
    ] -> null
  - networking_vpc_id                      = "vpc-0b5c9a35a431fd223" -> null
aws_kms_alias.secrets: Destroying... [id=alias/prd-eks-secrets-us-east-1]
aws_iam_openid_connect_provider.this: Destroying... [id=arn:aws:iam::659942169599:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/3D73689BCA1D30C3D7BCBEACA91F7775]
aws_eks_node_group.this: Destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1]
aws_kms_alias.secrets: Destruction complete after 1s
aws_iam_openid_connect_provider.this: Destruction complete after 1s
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 00m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 00m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 00m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 00m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 00m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 01m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 01m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 01m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 01m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 01m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 01m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 02m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 02m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 02m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 02m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 02m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 02m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 03m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 03m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 03m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 03m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 03m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 03m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 04m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 04m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 04m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 04m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 04m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 04m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 05m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 05m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 05m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 05m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 05m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 05m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 06m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 06m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 06m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 06m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 06m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 06m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 07m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 07m10s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 07m20s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 07m30s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 07m40s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 07m50s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 08m00s elapsed]
aws_eks_node_group.this: Still destroying... [id=prd-eks-us-east-1:prd-eks-ng-us-east-1, 08m10s elapsed]
aws_eks_node_group.this: Destruction complete after 8m19s
aws_iam_role_policy_attachment.node_eks_worker_node_policy: Destroying... [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy]
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only: Destroying... [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly]
aws_iam_role_policy_attachment.node_eks_cni_policy: Destroying... [id=prd-eks-node-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy]
aws_eks_cluster.this: Destroying... [id=prd-eks-us-east-1]
aws_iam_role_policy_attachment.node_ec2_container_registry_read_only: Destruction complete after 1s
aws_iam_role_policy_attachment.node_eks_worker_node_policy: Destruction complete after 1s
aws_iam_role_policy_attachment.node_eks_cni_policy: Destruction complete after 1s
aws_iam_role.node: Destroying... [id=prd-eks-node-role-us-east-1]
aws_iam_role.node: Destruction complete after 1s
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 00m10s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 00m20s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 00m30s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 00m40s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 00m50s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 01m00s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 01m10s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 01m20s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 01m30s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 01m40s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 01m50s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 02m00s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 02m10s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 02m20s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 02m30s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 02m40s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 02m50s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 03m00s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 03m10s elapsed]
aws_eks_cluster.this: Still destroying... [id=prd-eks-us-east-1, 03m20s elapsed]
aws_eks_cluster.this: Destruction complete after 3m26s
aws_kms_key.secrets: Destroying... [id=8cc07429-e4e2-4026-ba03-ea220a22e95f]
aws_iam_role_policy_attachment.cluster_eks_cluster_policy: Destroying... [id=prd-eks-cluster-role-us-east-1/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy]
aws_cloudwatch_log_group.cluster: Destroying... [id=/aws/eks/prd-eks-us-east-1/cluster]
aws_kms_key.secrets: Destruction complete after 1s
aws_cloudwatch_log_group.cluster: Destruction complete after 1s
aws_iam_role_policy_attachment.cluster_eks_cluster_policy: Destruction complete after 1s
aws_iam_role.cluster: Destroying... [id=prd-eks-cluster-role-us-east-1]
aws_iam_role.cluster: Destruction complete after 1s

Destroy complete! Resources: 12 destroyed.
```

## Recursos remanescentes no state apos o destroy

```
(vazio — nenhum recurso remanescente no state)
```

---

## Historico anterior (ultimo deploy antes do destroy)

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
