# Deployment: 01-networking-stack-ai — STACK DESTRUIDA

> Registrado automaticamente por `.claude/skills/terraform-destroy/destroy.sh`
> apos `terraform destroy -auto-approve`. Nao editar manualmente.

- **Stack:** `01-networking-stack-ai`
- **Data do destroy (UTC):** 2026-08-30T13:39:36Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que destruiu:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do destroy

```
data.aws_availability_zones.available: Reading...
aws_cloudwatch_log_group.flow_logs[0]: Refreshing state... [id=/aws/vpc-flow-log/prd-networking]
aws_vpc.this: Refreshing state... [id=vpc-0a42c9826d1418879]
aws_iam_role.flow_logs[0]: Refreshing state... [id=prd-networking-networking-flow-logs-role]
data.aws_availability_zones.available: Read complete after 0s [id=sa-east-1]
aws_iam_role_policy.flow_logs[0]: Refreshing state... [id=prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy]
aws_internet_gateway.this: Refreshing state... [id=igw-0aa7745d90dc37ee7]
aws_route_table.public: Refreshing state... [id=rtb-0b8c89f9918f1c5ab]
aws_default_security_group.this: Refreshing state... [id=sg-085191f7fa694ddf2]
aws_subnet.public["sa-east-1a"]: Refreshing state... [id=subnet-0810c83bce80923bd]
aws_subnet.public["sa-east-1b"]: Refreshing state... [id=subnet-0fc0e10373fcdad78]
aws_route_table.private["shared"]: Refreshing state... [id=rtb-00d2fb1a5a25464d2]
aws_subnet.private["sa-east-1b"]: Refreshing state... [id=subnet-05951f11b5b880c67]
aws_flow_log.this[0]: Refreshing state... [id=fl-056b8c097e4054b69]
aws_subnet.private["sa-east-1a"]: Refreshing state... [id=subnet-0e6959a0ddbe1189e]
aws_default_network_acl.this: Refreshing state... [id=acl-04c21d91ea5a40b72]
aws_eip.nat["sa-east-1a"]: Refreshing state... [id=eipalloc-05509655b66cd213b]
aws_route.public_default: Refreshing state... [id=r-rtb-0b8c89f9918f1c5ab1080289494]
aws_route_table_association.public["sa-east-1a"]: Refreshing state... [id=rtbassoc-0a07f470c1839b4bc]
aws_route_table_association.public["sa-east-1b"]: Refreshing state... [id=rtbassoc-0c369ea810c18f059]
aws_route_table_association.private["sa-east-1a"]: Refreshing state... [id=rtbassoc-058ef32cd72c85c07]
aws_route_table_association.private["sa-east-1b"]: Refreshing state... [id=rtbassoc-03b555701817969e0]
aws_nat_gateway.this["sa-east-1a"]: Refreshing state... [id=nat-0b286ae8cb5f4b012]
aws_route.private_default["shared"]: Refreshing state... [id=r-rtb-00d2fb1a5a25464d21080289494]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_cloudwatch_log_group.flow_logs[0] will be destroyed
  - resource "aws_cloudwatch_log_group" "flow_logs" {
      - arn                         = "arn:aws:logs:sa-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking" -> null
      - deletion_protection_enabled = false -> null
      - id                          = "/aws/vpc-flow-log/prd-networking" -> null
      - log_group_class             = "STANDARD" -> null
      - name                        = "/aws/vpc-flow-log/prd-networking" -> null
      - region                      = "sa-east-1" -> null
      - retention_in_days           = 30 -> null
      - skip_destroy                = false -> null
      - tags                        = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-flow-log-group"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                    = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-flow-log-group"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
        # (2 unchanged attributes hidden)
    }

  # aws_default_network_acl.this will be destroyed
  - resource "aws_default_network_acl" "this" {
      - arn                    = "arn:aws:ec2:sa-east-1:659942169599:network-acl/acl-04c21d91ea5a40b72" -> null
      - default_network_acl_id = "acl-04c21d91ea5a40b72" -> null
      - id                     = "acl-04c21d91ea5a40b72" -> null
      - owner_id               = "659942169599" -> null
      - region                 = "sa-east-1" -> null
      - subnet_ids             = [
          - "subnet-05951f11b5b880c67",
          - "subnet-0810c83bce80923bd",
          - "subnet-0e6959a0ddbe1189e",
          - "subnet-0fc0e10373fcdad78",
        ] -> null
      - tags                   = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-default-nacl"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all               = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-default-nacl"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id                 = "vpc-0a42c9826d1418879" -> null

      - egress {
          - action          = "allow" -> null
          - cidr_block      = "0.0.0.0/0" -> null
          - from_port       = 0 -> null
          - icmp_code       = 0 -> null
          - icmp_type       = 0 -> null
          - protocol        = "-1" -> null
          - rule_no         = 100 -> null
          - to_port         = 0 -> null
            # (1 unchanged attribute hidden)
        }

      - ingress {
          - action          = "allow" -> null
          - cidr_block      = "0.0.0.0/0" -> null
          - from_port       = 0 -> null
          - icmp_code       = 0 -> null
          - icmp_type       = 0 -> null
          - protocol        = "-1" -> null
          - rule_no         = 100 -> null
          - to_port         = 0 -> null
            # (1 unchanged attribute hidden)
        }
    }

  # aws_default_security_group.this will be destroyed
  - resource "aws_default_security_group" "this" {
      - arn                    = "arn:aws:ec2:sa-east-1:659942169599:security-group/sg-085191f7fa694ddf2" -> null
      - description            = "default VPC security group" -> null
      - egress                 = [] -> null
      - id                     = "sg-085191f7fa694ddf2" -> null
      - ingress                = [] -> null
      - name                   = "default" -> null
      - owner_id               = "659942169599" -> null
      - region                 = "sa-east-1" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-default-sg"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all               = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-default-sg"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id                 = "vpc-0a42c9826d1418879" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_eip.nat["sa-east-1a"] will be destroyed
  - resource "aws_eip" "nat" {
      - allocation_id            = "eipalloc-05509655b66cd213b" -> null
      - arn                      = "arn:aws:ec2:sa-east-1:659942169599:elastic-ip/eipalloc-05509655b66cd213b" -> null
      - association_id           = "eipassoc-094ca34f59321d471" -> null
      - domain                   = "vpc" -> null
      - id                       = "eipalloc-05509655b66cd213b" -> null
      - network_border_group     = "sa-east-1" -> null
      - network_interface        = "eni-04235f6dffa0f9a80" -> null
      - private_dns              = "ip-10-0-0-44.sa-east-1.compute.internal" -> null
      - private_ip               = "10.0.0.44" -> null
      - public_dns               = "ec2-52-67-55-128.sa-east-1.compute.amazonaws.com" -> null
      - public_ip                = "52.67.55.128" -> null
      - public_ipv4_pool         = "amazon" -> null
      - region                   = "sa-east-1" -> null
      - tags                     = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-eip-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                 = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-eip-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
        # (6 unchanged attributes hidden)
    }

  # aws_flow_log.this[0] will be destroyed
  - resource "aws_flow_log" "this" {
      - arn                        = "arn:aws:ec2:sa-east-1:659942169599:vpc-flow-log/fl-056b8c097e4054b69" -> null
      - iam_role_arn               = "arn:aws:iam::659942169599:role/prd-networking-networking-flow-logs-role" -> null
      - id                         = "fl-056b8c097e4054b69" -> null
      - log_destination            = "arn:aws:logs:sa-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking" -> null
      - log_destination_type       = "cloud-watch-logs" -> null
      - log_format                 = "${version} ${account-id} ${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport} ${protocol} ${packets} ${bytes} ${start} ${end} ${action} ${log-status}" -> null
      - max_aggregation_interval   = 600 -> null
      - region                     = "sa-east-1" -> null
      - tags                       = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-flow-log"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                   = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-flow-log"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - traffic_type               = "ALL" -> null
      - vpc_id                     = "vpc-0a42c9826d1418879" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_iam_role.flow_logs[0] will be destroyed
  - resource "aws_iam_role" "flow_logs" {
      - arn                   = "arn:aws:iam::659942169599:role/prd-networking-networking-flow-logs-role" -> null
      - assume_role_policy    = jsonencode(
            {
              - Statement = [
                  - {
                      - Action    = "sts:AssumeRole"
                      - Effect    = "Allow"
                      - Principal = {
                          - Service = "vpc-flow-logs.amazonaws.com"
                        }
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> null
      - create_date           = "2026-08-30T13:10:45Z" -> null
      - force_detach_policies = false -> null
      - id                    = "prd-networking-networking-flow-logs-role" -> null
      - managed_policy_arns   = [] -> null
      - max_session_duration  = 3600 -> null
      - name                  = "prd-networking-networking-flow-logs-role" -> null
      - path                  = "/" -> null
      - tags                  = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-flow-logs-role"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all              = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-flow-logs-role"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - unique_id             = "AROAZTJ46LP72HLZT4ZHP" -> null
        # (3 unchanged attributes hidden)

      - inline_policy {
          - name   = "prd-networking-networking-flow-logs-policy" -> null
          - policy = jsonencode(
                {
                  - Statement = [
                      - {
                          - Action   = [
                              - "logs:CreateLogGroup",
                              - "logs:CreateLogStream",
                              - "logs:PutLogEvents",
                              - "logs:DescribeLogGroups",
                              - "logs:DescribeLogStreams",
                            ]
                          - Effect   = "Allow"
                          - Resource = "arn:aws:logs:sa-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking:*"
                        },
                    ]
                  - Version   = "2012-10-17"
                }
            ) -> null
        }
    }

  # aws_iam_role_policy.flow_logs[0] will be destroyed
  - resource "aws_iam_role_policy" "flow_logs" {
      - id          = "prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy" -> null
      - name        = "prd-networking-networking-flow-logs-policy" -> null
      - policy      = jsonencode(
            {
              - Statement = [
                  - {
                      - Action   = [
                          - "logs:CreateLogGroup",
                          - "logs:CreateLogStream",
                          - "logs:PutLogEvents",
                          - "logs:DescribeLogGroups",
                          - "logs:DescribeLogStreams",
                        ]
                      - Effect   = "Allow"
                      - Resource = "arn:aws:logs:sa-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking:*"
                    },
                ]
              - Version   = "2012-10-17"
            }
        ) -> null
      - role        = "prd-networking-networking-flow-logs-role" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_internet_gateway.this will be destroyed
  - resource "aws_internet_gateway" "this" {
      - arn      = "arn:aws:ec2:sa-east-1:659942169599:internet-gateway/igw-0aa7745d90dc37ee7" -> null
      - id       = "igw-0aa7745d90dc37ee7" -> null
      - owner_id = "659942169599" -> null
      - region   = "sa-east-1" -> null
      - tags     = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-igw-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-igw-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id   = "vpc-0a42c9826d1418879" -> null
    }

  # aws_nat_gateway.this["sa-east-1a"] will be destroyed
  - resource "aws_nat_gateway" "this" {
      - allocation_id                      = "eipalloc-05509655b66cd213b" -> null
      - association_id                     = "eipassoc-094ca34f59321d471" -> null
      - availability_mode                  = "zonal" -> null
      - connectivity_type                  = "public" -> null
      - id                                 = "nat-0b286ae8cb5f4b012" -> null
      - network_interface_id               = "eni-04235f6dffa0f9a80" -> null
      - private_ip                         = "10.0.0.44" -> null
      - public_ip                          = "52.67.55.128" -> null
      - region                             = "sa-east-1" -> null
      - regional_nat_gateway_address       = [] -> null
      - secondary_allocation_ids           = [] -> null
      - secondary_private_ip_address_count = 0 -> null
      - secondary_private_ip_addresses     = [] -> null
      - subnet_id                          = "subnet-0810c83bce80923bd" -> null
      - tags                               = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id                             = "vpc-0a42c9826d1418879" -> null
    }

  # aws_route.private_default["shared"] will be destroyed
  - resource "aws_route" "private_default" {
      - destination_cidr_block      = "0.0.0.0/0" -> null
      - id                          = "r-rtb-00d2fb1a5a25464d21080289494" -> null
      - nat_gateway_id              = "nat-0b286ae8cb5f4b012" -> null
      - origin                      = "CreateRoute" -> null
      - region                      = "sa-east-1" -> null
      - route_table_id              = "rtb-00d2fb1a5a25464d2" -> null
      - state                       = "active" -> null
        # (14 unchanged attributes hidden)
    }

  # aws_route.public_default will be destroyed
  - resource "aws_route" "public_default" {
      - destination_cidr_block      = "0.0.0.0/0" -> null
      - gateway_id                  = "igw-0aa7745d90dc37ee7" -> null
      - id                          = "r-rtb-0b8c89f9918f1c5ab1080289494" -> null
      - origin                      = "CreateRoute" -> null
      - region                      = "sa-east-1" -> null
      - route_table_id              = "rtb-0b8c89f9918f1c5ab" -> null
      - state                       = "active" -> null
        # (14 unchanged attributes hidden)
    }

  # aws_route_table.private["shared"] will be destroyed
  - resource "aws_route_table" "private" {
      - arn              = "arn:aws:ec2:sa-east-1:659942169599:route-table/rtb-00d2fb1a5a25464d2" -> null
      - id               = "rtb-00d2fb1a5a25464d2" -> null
      - owner_id         = "659942169599" -> null
      - propagating_vgws = [] -> null
      - region           = "sa-east-1" -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - nat_gateway_id             = "nat-0b286ae8cb5f4b012"
                # (12 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-private-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all         = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-private-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id           = "vpc-0a42c9826d1418879" -> null
    }

  # aws_route_table.public will be destroyed
  - resource "aws_route_table" "public" {
      - arn              = "arn:aws:ec2:sa-east-1:659942169599:route-table/rtb-0b8c89f9918f1c5ab" -> null
      - id               = "rtb-0b8c89f9918f1c5ab" -> null
      - owner_id         = "659942169599" -> null
      - propagating_vgws = [] -> null
      - region           = "sa-east-1" -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - gateway_id                 = "igw-0aa7745d90dc37ee7"
                # (12 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-public-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all         = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-public-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id           = "vpc-0a42c9826d1418879" -> null
    }

  # aws_route_table_association.private["sa-east-1a"] will be destroyed
  - resource "aws_route_table_association" "private" {
      - id             = "rtbassoc-058ef32cd72c85c07" -> null
      - region         = "sa-east-1" -> null
      - route_table_id = "rtb-00d2fb1a5a25464d2" -> null
      - subnet_id      = "subnet-0e6959a0ddbe1189e" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_route_table_association.private["sa-east-1b"] will be destroyed
  - resource "aws_route_table_association" "private" {
      - id             = "rtbassoc-03b555701817969e0" -> null
      - region         = "sa-east-1" -> null
      - route_table_id = "rtb-00d2fb1a5a25464d2" -> null
      - subnet_id      = "subnet-05951f11b5b880c67" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_route_table_association.public["sa-east-1a"] will be destroyed
  - resource "aws_route_table_association" "public" {
      - id             = "rtbassoc-0a07f470c1839b4bc" -> null
      - region         = "sa-east-1" -> null
      - route_table_id = "rtb-0b8c89f9918f1c5ab" -> null
      - subnet_id      = "subnet-0810c83bce80923bd" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_route_table_association.public["sa-east-1b"] will be destroyed
  - resource "aws_route_table_association" "public" {
      - id             = "rtbassoc-0c369ea810c18f059" -> null
      - region         = "sa-east-1" -> null
      - route_table_id = "rtb-0b8c89f9918f1c5ab" -> null
      - subnet_id      = "subnet-0fc0e10373fcdad78" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_subnet.private["sa-east-1a"] will be destroyed
  - resource "aws_subnet" "private" {
      - arn                                            = "arn:aws:ec2:sa-east-1:659942169599:subnet/subnet-0e6959a0ddbe1189e" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "sa-east-1a" -> null
      - availability_zone_id                           = "sae1-az1" -> null
      - cidr_block                                     = "10.0.0.128/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0e6959a0ddbe1189e" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "sa-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-private-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "private"
        } -> null
      - tags_all                                       = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-private-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "private"
        } -> null
      - vpc_id                                         = "vpc-0a42c9826d1418879" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_subnet.private["sa-east-1b"] will be destroyed
  - resource "aws_subnet" "private" {
      - arn                                            = "arn:aws:ec2:sa-east-1:659942169599:subnet/subnet-05951f11b5b880c67" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "sa-east-1b" -> null
      - availability_zone_id                           = "sae1-az2" -> null
      - cidr_block                                     = "10.0.0.192/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-05951f11b5b880c67" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "sa-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-private-sa-east-1b"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "private"
        } -> null
      - tags_all                                       = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-private-sa-east-1b"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "private"
        } -> null
      - vpc_id                                         = "vpc-0a42c9826d1418879" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_subnet.public["sa-east-1a"] will be destroyed
  - resource "aws_subnet" "public" {
      - arn                                            = "arn:aws:ec2:sa-east-1:659942169599:subnet/subnet-0810c83bce80923bd" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "sa-east-1a" -> null
      - availability_zone_id                           = "sae1-az1" -> null
      - cidr_block                                     = "10.0.0.0/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0810c83bce80923bd" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = true -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "sa-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-public-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "public"
        } -> null
      - tags_all                                       = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-public-sa-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "public"
        } -> null
      - vpc_id                                         = "vpc-0a42c9826d1418879" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_subnet.public["sa-east-1b"] will be destroyed
  - resource "aws_subnet" "public" {
      - arn                                            = "arn:aws:ec2:sa-east-1:659942169599:subnet/subnet-0fc0e10373fcdad78" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "sa-east-1b" -> null
      - availability_zone_id                           = "sae1-az2" -> null
      - cidr_block                                     = "10.0.0.64/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0fc0e10373fcdad78" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = true -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "sa-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-public-sa-east-1b"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "public"
        } -> null
      - tags_all                                       = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-public-sa-east-1b"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "public"
        } -> null
      - vpc_id                                         = "vpc-0a42c9826d1418879" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_vpc.this will be destroyed
  - resource "aws_vpc" "this" {
      - arn                                  = "arn:aws:ec2:sa-east-1:659942169599:vpc/vpc-0a42c9826d1418879" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/24" -> null
      - default_network_acl_id               = "acl-04c21d91ea5a40b72" -> null
      - default_route_table_id               = "rtb-0c9231b463f2ee871" -> null
      - default_security_group_id            = "sg-085191f7fa694ddf2" -> null
      - dhcp_options_id                      = "dopt-0b7e99f894d5a60cb" -> null
      - enable_dns_hostnames                 = true -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-0a42c9826d1418879" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-0c9231b463f2ee871" -> null
      - owner_id                             = "659942169599" -> null
      - region                               = "sa-east-1" -> null
      - tags                                 = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-vpc-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                             = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-vpc-sa-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
        # (4 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 22 to destroy.

Changes to Outputs:
  - internet_gateway_id      = "igw-0aa7745d90dc37ee7" -> null
  - nat_gateway_ids          = [
      - "nat-0b286ae8cb5f4b012",
    ] -> null
  - nat_gateway_public_ips   = [
      - "52.67.55.128",
    ] -> null
  - private_route_tables_ids = [
      - "rtb-00d2fb1a5a25464d2",
    ] -> null
  - private_subnets_ids      = [
      - "subnet-0e6959a0ddbe1189e",
      - "subnet-05951f11b5b880c67",
    ] -> null
  - public_route_tables_ids  = [
      - "rtb-0b8c89f9918f1c5ab",
    ] -> null
  - public_subnets_ids       = [
      - "subnet-0810c83bce80923bd",
      - "subnet-0fc0e10373fcdad78",
    ] -> null
  - vpc_availability_zones   = [
      - "sa-east-1a",
      - "sa-east-1b",
    ] -> null
  - vpc_cidr_block           = "10.0.0.0/24" -> null
  - vpc_id                   = "vpc-0a42c9826d1418879" -> null
aws_route_table_association.public["sa-east-1b"]: Destroying... [id=rtbassoc-0c369ea810c18f059]
aws_route_table_association.private["sa-east-1b"]: Destroying... [id=rtbassoc-03b555701817969e0]
aws_default_security_group.this: Destroying... [id=sg-085191f7fa694ddf2]
aws_route_table_association.public["sa-east-1a"]: Destroying... [id=rtbassoc-0a07f470c1839b4bc]
aws_route.public_default: Destroying... [id=r-rtb-0b8c89f9918f1c5ab1080289494]
aws_flow_log.this[0]: Destroying... [id=fl-056b8c097e4054b69]
aws_route_table_association.private["sa-east-1a"]: Destroying... [id=rtbassoc-058ef32cd72c85c07]
aws_route.private_default["shared"]: Destroying... [id=r-rtb-00d2fb1a5a25464d21080289494]
aws_iam_role_policy.flow_logs[0]: Destroying... [id=prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy]
aws_default_network_acl.this: Destroying... [id=acl-04c21d91ea5a40b72]
aws_default_security_group.this: Destruction complete after 0s
aws_default_network_acl.this: Destruction complete after 0s
aws_flow_log.this[0]: Destruction complete after 0s
aws_iam_role_policy.flow_logs[0]: Destruction complete after 0s
aws_cloudwatch_log_group.flow_logs[0]: Destroying... [id=/aws/vpc-flow-log/prd-networking]
aws_iam_role.flow_logs[0]: Destroying... [id=prd-networking-networking-flow-logs-role]
aws_route_table_association.private["sa-east-1b"]: Destruction complete after 0s
aws_route_table_association.public["sa-east-1b"]: Destruction complete after 0s
aws_route_table_association.private["sa-east-1a"]: Destruction complete after 0s
aws_subnet.private["sa-east-1a"]: Destroying... [id=subnet-0e6959a0ddbe1189e]
aws_subnet.private["sa-east-1b"]: Destroying... [id=subnet-05951f11b5b880c67]
aws_route_table_association.public["sa-east-1a"]: Destruction complete after 1s
aws_route.private_default["shared"]: Destruction complete after 1s
aws_route.public_default: Destruction complete after 1s
aws_route_table.private["shared"]: Destroying... [id=rtb-00d2fb1a5a25464d2]
aws_nat_gateway.this["sa-east-1a"]: Destroying... [id=nat-0b286ae8cb5f4b012]
aws_route_table.public: Destroying... [id=rtb-0b8c89f9918f1c5ab]
aws_cloudwatch_log_group.flow_logs[0]: Destruction complete after 1s
aws_iam_role.flow_logs[0]: Destruction complete after 1s
aws_subnet.private["sa-east-1b"]: Destruction complete after 1s
aws_subnet.private["sa-east-1a"]: Destruction complete after 1s
aws_route_table.public: Destruction complete after 0s
aws_route_table.private["shared"]: Destruction complete after 1s
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 00m10s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 00m20s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 00m30s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 00m40s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 00m50s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 01m00s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 01m10s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 01m20s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 01m30s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 01m40s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still destroying... [id=nat-0b286ae8cb5f4b012, 01m50s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Destruction complete after 1m51s
aws_eip.nat["sa-east-1a"]: Destroying... [id=eipalloc-05509655b66cd213b]
aws_subnet.public["sa-east-1b"]: Destroying... [id=subnet-0fc0e10373fcdad78]
aws_subnet.public["sa-east-1a"]: Destroying... [id=subnet-0810c83bce80923bd]
aws_subnet.public["sa-east-1a"]: Destruction complete after 1s
aws_subnet.public["sa-east-1b"]: Destruction complete after 1s
aws_eip.nat["sa-east-1a"]: Destruction complete after 1s
aws_internet_gateway.this: Destroying... [id=igw-0aa7745d90dc37ee7]
aws_internet_gateway.this: Destruction complete after 1s
aws_vpc.this: Destroying... [id=vpc-0a42c9826d1418879]
aws_vpc.this: Destruction complete after 1s

Destroy complete! Resources: 22 destroyed.
```

## Recursos remanescentes no state apos o destroy

```
(vazio — nenhum recurso remanescente no state)
```

---

## Historico anterior (ultimo deploy antes do destroy)

# Deployment: 01-networking-stack-ai

> Gerado automaticamente por `.claude/skills/terraform-deploy/deploy.sh`
> apos `terraform apply -auto-approve`. Nao editar manualmente —
> este arquivo e sobrescrito no proximo deploy desta stack.

- **Stack:** `01-networking-stack-ai`
- **Data do apply (UTC):** 2026-08-30T13:12:51Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que aplicou:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do apply

```
aws_cloudwatch_log_group.flow_logs[0]: Creating...
aws_iam_role.flow_logs[0]: Creating...
aws_vpc.this: Creating...
aws_cloudwatch_log_group.flow_logs[0]: Creation complete after 1s [id=/aws/vpc-flow-log/prd-networking]
aws_iam_role.flow_logs[0]: Creation complete after 1s [id=prd-networking-networking-flow-logs-role]
aws_iam_role_policy.flow_logs[0]: Creating...
aws_iam_role_policy.flow_logs[0]: Creation complete after 1s [id=prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy]
aws_vpc.this: Creation complete after 3s [id=vpc-0a42c9826d1418879]
aws_internet_gateway.this: Creating...
aws_subnet.public["sa-east-1b"]: Creating...
aws_default_network_acl.this: Creating...
aws_route_table.public: Creating...
aws_subnet.private["sa-east-1a"]: Creating...
aws_route_table.private["shared"]: Creating...
aws_subnet.public["sa-east-1a"]: Creating...
aws_subnet.private["sa-east-1b"]: Creating...
aws_flow_log.this[0]: Creating...
aws_default_security_group.this: Creating...
aws_flow_log.this[0]: Creation complete after 1s [id=fl-056b8c097e4054b69]
aws_internet_gateway.this: Creation complete after 1s [id=igw-0aa7745d90dc37ee7]
aws_eip.nat["sa-east-1a"]: Creating...
aws_route_table.public: Creation complete after 1s [id=rtb-0b8c89f9918f1c5ab]
aws_route.public_default: Creating...
aws_route_table.private["shared"]: Creation complete after 1s [id=rtb-00d2fb1a5a25464d2]
aws_subnet.private["sa-east-1a"]: Creation complete after 1s [id=subnet-0e6959a0ddbe1189e]
aws_subnet.private["sa-east-1b"]: Creation complete after 2s [id=subnet-05951f11b5b880c67]
aws_default_network_acl.this: Creation complete after 2s [id=acl-04c21d91ea5a40b72]
aws_route_table_association.private["sa-east-1b"]: Creating...
aws_route_table_association.private["sa-east-1a"]: Creating...
aws_eip.nat["sa-east-1a"]: Creation complete after 1s [id=eipalloc-05509655b66cd213b]
aws_route.public_default: Creation complete after 1s [id=r-rtb-0b8c89f9918f1c5ab1080289494]
aws_route_table_association.private["sa-east-1a"]: Creation complete after 0s [id=rtbassoc-058ef32cd72c85c07]
aws_route_table_association.private["sa-east-1b"]: Creation complete after 0s [id=rtbassoc-03b555701817969e0]
aws_default_security_group.this: Creation complete after 3s [id=sg-085191f7fa694ddf2]
aws_subnet.public["sa-east-1b"]: Still creating... [00m10s elapsed]
aws_subnet.public["sa-east-1a"]: Still creating... [00m10s elapsed]
aws_subnet.public["sa-east-1b"]: Creation complete after 12s [id=subnet-0fc0e10373fcdad78]
aws_subnet.public["sa-east-1a"]: Creation complete after 15s [id=subnet-0810c83bce80923bd]
aws_route_table_association.public["sa-east-1a"]: Creating...
aws_route_table_association.public["sa-east-1b"]: Creating...
aws_nat_gateway.this["sa-east-1a"]: Creating...
aws_route_table_association.public["sa-east-1b"]: Creation complete after 1s [id=rtbassoc-0c369ea810c18f059]
aws_route_table_association.public["sa-east-1a"]: Creation complete after 1s [id=rtbassoc-0a07f470c1839b4bc]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m10s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m20s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m30s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m40s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m50s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [01m00s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [01m10s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [01m20s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [01m30s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [01m40s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Creation complete after 1m46s [id=nat-0b286ae8cb5f4b012]
aws_route.private_default["shared"]: Creating...
aws_route.private_default["shared"]: Creation complete after 1s [id=r-rtb-00d2fb1a5a25464d21080289494]

Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

internet_gateway_id = "igw-0aa7745d90dc37ee7"
nat_gateway_ids = [
  "nat-0b286ae8cb5f4b012",
]
nat_gateway_public_ips = [
  "52.67.55.128",
]
private_route_tables_ids = [
  "rtb-00d2fb1a5a25464d2",
]
private_subnets_ids = [
  "subnet-0e6959a0ddbe1189e",
  "subnet-05951f11b5b880c67",
]
public_route_tables_ids = [
  "rtb-0b8c89f9918f1c5ab",
]
public_subnets_ids = [
  "subnet-0810c83bce80923bd",
  "subnet-0fc0e10373fcdad78",
]
vpc_availability_zones = tolist([
  "sa-east-1a",
  "sa-east-1b",
])
vpc_cidr_block = "10.0.0.0/24"
vpc_id = "vpc-0a42c9826d1418879"
```

## Outputs

```json
{
  "internet_gateway_id": {
    "sensitive": false,
    "type": "string",
    "value": "igw-0aa7745d90dc37ee7"
  },
  "nat_gateway_ids": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string"
      ]
    ],
    "value": [
      "nat-0b286ae8cb5f4b012"
    ]
  },
  "nat_gateway_public_ips": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string"
      ]
    ],
    "value": [
      "52.67.55.128"
    ]
  },
  "private_route_tables_ids": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string"
      ]
    ],
    "value": [
      "rtb-00d2fb1a5a25464d2"
    ]
  },
  "private_subnets_ids": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string",
        "string"
      ]
    ],
    "value": [
      "subnet-0e6959a0ddbe1189e",
      "subnet-05951f11b5b880c67"
    ]
  },
  "public_route_tables_ids": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string"
      ]
    ],
    "value": [
      "rtb-0b8c89f9918f1c5ab"
    ]
  },
  "public_subnets_ids": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string",
        "string"
      ]
    ],
    "value": [
      "subnet-0810c83bce80923bd",
      "subnet-0fc0e10373fcdad78"
    ]
  },
  "vpc_availability_zones": {
    "sensitive": false,
    "type": [
      "list",
      "string"
    ],
    "value": [
      "sa-east-1a",
      "sa-east-1b"
    ]
  },
  "vpc_cidr_block": {
    "sensitive": false,
    "type": "string",
    "value": "10.0.0.0/24"
  },
  "vpc_id": {
    "sensitive": false,
    "type": "string",
    "value": "vpc-0a42c9826d1418879"
  }
}
```

## Recursos no state

```
data.aws_availability_zones.available
aws_cloudwatch_log_group.flow_logs[0]
aws_default_network_acl.this
aws_default_security_group.this
aws_eip.nat["sa-east-1a"]
aws_flow_log.this[0]
aws_iam_role.flow_logs[0]
aws_iam_role_policy.flow_logs[0]
aws_internet_gateway.this
aws_nat_gateway.this["sa-east-1a"]
aws_route.private_default["shared"]
aws_route.public_default
aws_route_table.private["shared"]
aws_route_table.public
aws_route_table_association.private["sa-east-1a"]
aws_route_table_association.private["sa-east-1b"]
aws_route_table_association.public["sa-east-1a"]
aws_route_table_association.public["sa-east-1b"]
aws_subnet.private["sa-east-1a"]
aws_subnet.private["sa-east-1b"]
aws_subnet.public["sa-east-1a"]
aws_subnet.public["sa-east-1b"]
aws_vpc.this
```
