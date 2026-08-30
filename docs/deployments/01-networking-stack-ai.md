# Deployment: 01-networking-stack-ai — STACK DESTRUIDA

> Registrado automaticamente por `.claude/skills/terraform-destroy/destroy.sh`
> apos `terraform destroy -auto-approve`. Nao editar manualmente.

- **Stack:** `01-networking-stack-ai`
- **Data do destroy (UTC):** 2026-08-30T16:44:40Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que destruiu:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do destroy

```
data.aws_availability_zones.available: Reading...
aws_cloudwatch_log_group.flow_logs[0]: Refreshing state... [id=/aws/vpc-flow-log/prd-networking]
aws_iam_role.flow_logs[0]: Refreshing state... [id=prd-networking-networking-flow-logs-role]
aws_vpc.this: Refreshing state... [id=vpc-0b5c9a35a431fd223]
data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]
aws_iam_role_policy.flow_logs[0]: Refreshing state... [id=prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy]
aws_default_security_group.this: Refreshing state... [id=sg-027f4e10d62b9cc99]
aws_internet_gateway.this: Refreshing state... [id=igw-0f9a35a77f9b9d64d]
aws_route_table.private["shared"]: Refreshing state... [id=rtb-0dbfd7a46217d6c52]
aws_flow_log.this[0]: Refreshing state... [id=fl-093072eb54747b85f]
aws_subnet.private["us-east-1b"]: Refreshing state... [id=subnet-0c6fcdfd9dc8b0967]
aws_subnet.private["us-east-1a"]: Refreshing state... [id=subnet-0f9f6bd9df3aab8bf]
aws_route_table.public: Refreshing state... [id=rtb-054316e5b84519b52]
aws_subnet.public["us-east-1b"]: Refreshing state... [id=subnet-059b33c4972f1f3ca]
aws_subnet.public["us-east-1a"]: Refreshing state... [id=subnet-0ec73e30e5d4a81b3]
aws_default_network_acl.this: Refreshing state... [id=acl-0852d899abc9011fe]
aws_eip.nat["us-east-1a"]: Refreshing state... [id=eipalloc-082634cf000ac13df]
aws_route_table_association.private["us-east-1a"]: Refreshing state... [id=rtbassoc-0ba968f0b2ab6f44f]
aws_route_table_association.private["us-east-1b"]: Refreshing state... [id=rtbassoc-0d3d8bbe89201d60c]
aws_route.public_default: Refreshing state... [id=r-rtb-054316e5b84519b521080289494]
aws_route_table_association.public["us-east-1a"]: Refreshing state... [id=rtbassoc-09b5d8b972a406992]
aws_route_table_association.public["us-east-1b"]: Refreshing state... [id=rtbassoc-0a44411aed869fdaa]
aws_nat_gateway.this["us-east-1a"]: Refreshing state... [id=nat-0767bc502e7e287ef]
aws_route.private_default["shared"]: Refreshing state... [id=r-rtb-0dbfd7a46217d6c521080289494]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_cloudwatch_log_group.flow_logs[0] will be destroyed
  - resource "aws_cloudwatch_log_group" "flow_logs" {
      - arn                         = "arn:aws:logs:us-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking" -> null
      - deletion_protection_enabled = false -> null
      - id                          = "/aws/vpc-flow-log/prd-networking" -> null
      - log_group_class             = "STANDARD" -> null
      - name                        = "/aws/vpc-flow-log/prd-networking" -> null
      - region                      = "us-east-1" -> null
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
      - arn                    = "arn:aws:ec2:us-east-1:659942169599:network-acl/acl-0852d899abc9011fe" -> null
      - default_network_acl_id = "acl-0852d899abc9011fe" -> null
      - id                     = "acl-0852d899abc9011fe" -> null
      - owner_id               = "659942169599" -> null
      - region                 = "us-east-1" -> null
      - subnet_ids             = [
          - "subnet-059b33c4972f1f3ca",
          - "subnet-0c6fcdfd9dc8b0967",
          - "subnet-0ec73e30e5d4a81b3",
          - "subnet-0f9f6bd9df3aab8bf",
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
      - vpc_id                 = "vpc-0b5c9a35a431fd223" -> null

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
      - arn                    = "arn:aws:ec2:us-east-1:659942169599:security-group/sg-027f4e10d62b9cc99" -> null
      - description            = "default VPC security group" -> null
      - egress                 = [] -> null
      - id                     = "sg-027f4e10d62b9cc99" -> null
      - ingress                = [] -> null
      - name                   = "default" -> null
      - owner_id               = "659942169599" -> null
      - region                 = "us-east-1" -> null
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
      - vpc_id                 = "vpc-0b5c9a35a431fd223" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_eip.nat["us-east-1a"] will be destroyed
  - resource "aws_eip" "nat" {
      - allocation_id            = "eipalloc-082634cf000ac13df" -> null
      - arn                      = "arn:aws:ec2:us-east-1:659942169599:elastic-ip/eipalloc-082634cf000ac13df" -> null
      - association_id           = "eipassoc-0374e0175c8a8c5c4" -> null
      - domain                   = "vpc" -> null
      - id                       = "eipalloc-082634cf000ac13df" -> null
      - network_border_group     = "us-east-1" -> null
      - network_interface        = "eni-0db9a0daa2e218564" -> null
      - private_dns              = "ip-10-0-0-57.ec2.internal" -> null
      - private_ip               = "10.0.0.57" -> null
      - public_dns               = "ec2-3-220-58-118.compute-1.amazonaws.com" -> null
      - public_ip                = "3.220.58.118" -> null
      - public_ipv4_pool         = "amazon" -> null
      - region                   = "us-east-1" -> null
      - tags                     = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-eip-us-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                 = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-eip-us-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
        # (6 unchanged attributes hidden)
    }

  # aws_flow_log.this[0] will be destroyed
  - resource "aws_flow_log" "this" {
      - arn                        = "arn:aws:ec2:us-east-1:659942169599:vpc-flow-log/fl-093072eb54747b85f" -> null
      - iam_role_arn               = "arn:aws:iam::659942169599:role/prd-networking-networking-flow-logs-role" -> null
      - id                         = "fl-093072eb54747b85f" -> null
      - log_destination            = "arn:aws:logs:us-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking" -> null
      - log_destination_type       = "cloud-watch-logs" -> null
      - log_format                 = "${version} ${account-id} ${interface-id} ${srcaddr} ${dstaddr} ${srcport} ${dstport} ${protocol} ${packets} ${bytes} ${start} ${end} ${action} ${log-status}" -> null
      - max_aggregation_interval   = 600 -> null
      - region                     = "us-east-1" -> null
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
      - vpc_id                     = "vpc-0b5c9a35a431fd223" -> null
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
      - create_date           = "2026-08-30T15:34:34Z" -> null
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
      - unique_id             = "AROAZTJ46LP73KSXC6VY6" -> null
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
                          - Resource = "arn:aws:logs:us-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking:*"
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
                      - Resource = "arn:aws:logs:us-east-1:659942169599:log-group:/aws/vpc-flow-log/prd-networking:*"
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
      - arn      = "arn:aws:ec2:us-east-1:659942169599:internet-gateway/igw-0f9a35a77f9b9d64d" -> null
      - id       = "igw-0f9a35a77f9b9d64d" -> null
      - owner_id = "659942169599" -> null
      - region   = "us-east-1" -> null
      - tags     = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-igw-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-igw-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id   = "vpc-0b5c9a35a431fd223" -> null
    }

  # aws_nat_gateway.this["us-east-1a"] will be destroyed
  - resource "aws_nat_gateway" "this" {
      - allocation_id                      = "eipalloc-082634cf000ac13df" -> null
      - association_id                     = "eipassoc-0374e0175c8a8c5c4" -> null
      - availability_mode                  = "zonal" -> null
      - connectivity_type                  = "public" -> null
      - id                                 = "nat-0767bc502e7e287ef" -> null
      - network_interface_id               = "eni-0db9a0daa2e218564" -> null
      - private_ip                         = "10.0.0.57" -> null
      - public_ip                          = "3.220.58.118" -> null
      - region                             = "us-east-1" -> null
      - regional_nat_gateway_address       = [] -> null
      - secondary_allocation_ids           = [] -> null
      - secondary_private_ip_address_count = 0 -> null
      - secondary_private_ip_addresses     = [] -> null
      - subnet_id                          = "subnet-0ec73e30e5d4a81b3" -> null
      - tags                               = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-us-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-nat-us-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id                             = "vpc-0b5c9a35a431fd223" -> null
    }

  # aws_route.private_default["shared"] will be destroyed
  - resource "aws_route" "private_default" {
      - destination_cidr_block      = "0.0.0.0/0" -> null
      - id                          = "r-rtb-0dbfd7a46217d6c521080289494" -> null
      - nat_gateway_id              = "nat-0767bc502e7e287ef" -> null
      - origin                      = "CreateRoute" -> null
      - region                      = "us-east-1" -> null
      - route_table_id              = "rtb-0dbfd7a46217d6c52" -> null
      - state                       = "active" -> null
        # (14 unchanged attributes hidden)
    }

  # aws_route.public_default will be destroyed
  - resource "aws_route" "public_default" {
      - destination_cidr_block      = "0.0.0.0/0" -> null
      - gateway_id                  = "igw-0f9a35a77f9b9d64d" -> null
      - id                          = "r-rtb-054316e5b84519b521080289494" -> null
      - origin                      = "CreateRoute" -> null
      - region                      = "us-east-1" -> null
      - route_table_id              = "rtb-054316e5b84519b52" -> null
      - state                       = "active" -> null
        # (14 unchanged attributes hidden)
    }

  # aws_route_table.private["shared"] will be destroyed
  - resource "aws_route_table" "private" {
      - arn              = "arn:aws:ec2:us-east-1:659942169599:route-table/rtb-0dbfd7a46217d6c52" -> null
      - id               = "rtb-0dbfd7a46217d6c52" -> null
      - owner_id         = "659942169599" -> null
      - propagating_vgws = [] -> null
      - region           = "us-east-1" -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - nat_gateway_id             = "nat-0767bc502e7e287ef"
                # (12 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-private-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all         = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-private-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id           = "vpc-0b5c9a35a431fd223" -> null
    }

  # aws_route_table.public will be destroyed
  - resource "aws_route_table" "public" {
      - arn              = "arn:aws:ec2:us-east-1:659942169599:route-table/rtb-054316e5b84519b52" -> null
      - id               = "rtb-054316e5b84519b52" -> null
      - owner_id         = "659942169599" -> null
      - propagating_vgws = [] -> null
      - region           = "us-east-1" -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - gateway_id                 = "igw-0f9a35a77f9b9d64d"
                # (12 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-public-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all         = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-rt-public-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - vpc_id           = "vpc-0b5c9a35a431fd223" -> null
    }

  # aws_route_table_association.private["us-east-1a"] will be destroyed
  - resource "aws_route_table_association" "private" {
      - id             = "rtbassoc-0ba968f0b2ab6f44f" -> null
      - region         = "us-east-1" -> null
      - route_table_id = "rtb-0dbfd7a46217d6c52" -> null
      - subnet_id      = "subnet-0f9f6bd9df3aab8bf" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_route_table_association.private["us-east-1b"] will be destroyed
  - resource "aws_route_table_association" "private" {
      - id             = "rtbassoc-0d3d8bbe89201d60c" -> null
      - region         = "us-east-1" -> null
      - route_table_id = "rtb-0dbfd7a46217d6c52" -> null
      - subnet_id      = "subnet-0c6fcdfd9dc8b0967" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_route_table_association.public["us-east-1a"] will be destroyed
  - resource "aws_route_table_association" "public" {
      - id             = "rtbassoc-09b5d8b972a406992" -> null
      - region         = "us-east-1" -> null
      - route_table_id = "rtb-054316e5b84519b52" -> null
      - subnet_id      = "subnet-0ec73e30e5d4a81b3" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_route_table_association.public["us-east-1b"] will be destroyed
  - resource "aws_route_table_association" "public" {
      - id             = "rtbassoc-0a44411aed869fdaa" -> null
      - region         = "us-east-1" -> null
      - route_table_id = "rtb-054316e5b84519b52" -> null
      - subnet_id      = "subnet-059b33c4972f1f3ca" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_subnet.private["us-east-1a"] will be destroyed
  - resource "aws_subnet" "private" {
      - arn                                            = "arn:aws:ec2:us-east-1:659942169599:subnet/subnet-0f9f6bd9df3aab8bf" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1a" -> null
      - availability_zone_id                           = "use1-az4" -> null
      - cidr_block                                     = "10.0.0.128/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0f9f6bd9df3aab8bf" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "us-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-private-us-east-1a"
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
          - "Name"               = "prd-networking-networking-private-us-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "private"
        } -> null
      - vpc_id                                         = "vpc-0b5c9a35a431fd223" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_subnet.private["us-east-1b"] will be destroyed
  - resource "aws_subnet" "private" {
      - arn                                            = "arn:aws:ec2:us-east-1:659942169599:subnet/subnet-0c6fcdfd9dc8b0967" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1b" -> null
      - availability_zone_id                           = "use1-az6" -> null
      - cidr_block                                     = "10.0.0.192/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0c6fcdfd9dc8b0967" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "us-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-private-us-east-1b"
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
          - "Name"               = "prd-networking-networking-private-us-east-1b"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "private"
        } -> null
      - vpc_id                                         = "vpc-0b5c9a35a431fd223" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_subnet.public["us-east-1a"] will be destroyed
  - resource "aws_subnet" "public" {
      - arn                                            = "arn:aws:ec2:us-east-1:659942169599:subnet/subnet-0ec73e30e5d4a81b3" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1a" -> null
      - availability_zone_id                           = "use1-az4" -> null
      - cidr_block                                     = "10.0.0.0/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0ec73e30e5d4a81b3" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = true -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "us-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-public-us-east-1a"
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
          - "Name"               = "prd-networking-networking-public-us-east-1a"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "public"
        } -> null
      - vpc_id                                         = "vpc-0b5c9a35a431fd223" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_subnet.public["us-east-1b"] will be destroyed
  - resource "aws_subnet" "public" {
      - arn                                            = "arn:aws:ec2:us-east-1:659942169599:subnet/subnet-059b33c4972f1f3ca" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1b" -> null
      - availability_zone_id                           = "use1-az6" -> null
      - cidr_block                                     = "10.0.0.64/26" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-059b33c4972f1f3ca" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = true -> null
      - owner_id                                       = "659942169599" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - region                                         = "us-east-1" -> null
      - tags                                           = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-public-us-east-1b"
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
          - "Name"               = "prd-networking-networking-public-us-east-1b"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
          - "Tier"               = "public"
        } -> null
      - vpc_id                                         = "vpc-0b5c9a35a431fd223" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_vpc.this will be destroyed
  - resource "aws_vpc" "this" {
      - arn                                  = "arn:aws:ec2:us-east-1:659942169599:vpc/vpc-0b5c9a35a431fd223" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/24" -> null
      - default_network_acl_id               = "acl-0852d899abc9011fe" -> null
      - default_route_table_id               = "rtb-0affa7506e6e6f2d1" -> null
      - default_security_group_id            = "sg-027f4e10d62b9cc99" -> null
      - dhcp_options_id                      = "dopt-06404416634b9d927" -> null
      - enable_dns_hostnames                 = true -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-0b5c9a35a431fd223" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-0affa7506e6e6f2d1" -> null
      - owner_id                             = "659942169599" -> null
      - region                               = "us-east-1" -> null
      - tags                                 = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-vpc-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
      - tags_all                             = {
          - "CostCenter"         = "wdn"
          - "DataClassification" = "internal"
          - "Environment"        = "prd"
          - "ManagedBy"          = "terraform"
          - "Name"               = "prd-networking-networking-vpc-us-east-1"
          - "Owner"              = "Leopoldo Cardoso"
          - "Project"            = "networking"
          - "StackName"          = "01-networking-stack-ai"
        } -> null
        # (4 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 22 to destroy.

Changes to Outputs:
  - internet_gateway_id      = "igw-0f9a35a77f9b9d64d" -> null
  - nat_gateway_ids          = [
      - "nat-0767bc502e7e287ef",
    ] -> null
  - nat_gateway_public_ips   = [
      - "3.220.58.118",
    ] -> null
  - private_route_tables_ids = [
      - "rtb-0dbfd7a46217d6c52",
    ] -> null
  - private_subnets_ids      = [
      - "subnet-0f9f6bd9df3aab8bf",
      - "subnet-0c6fcdfd9dc8b0967",
    ] -> null
  - public_route_tables_ids  = [
      - "rtb-054316e5b84519b52",
    ] -> null
  - public_subnets_ids       = [
      - "subnet-0ec73e30e5d4a81b3",
      - "subnet-059b33c4972f1f3ca",
    ] -> null
  - vpc_availability_zones   = [
      - "us-east-1a",
      - "us-east-1b",
    ] -> null
  - vpc_cidr_block           = "10.0.0.0/24" -> null
  - vpc_id                   = "vpc-0b5c9a35a431fd223" -> null
aws_route_table_association.public["us-east-1a"]: Destroying... [id=rtbassoc-09b5d8b972a406992]
aws_route.public_default: Destroying... [id=r-rtb-054316e5b84519b521080289494]
aws_route_table_association.private["us-east-1b"]: Destroying... [id=rtbassoc-0d3d8bbe89201d60c]
aws_route_table_association.private["us-east-1a"]: Destroying... [id=rtbassoc-0ba968f0b2ab6f44f]
aws_flow_log.this[0]: Destroying... [id=fl-093072eb54747b85f]
aws_route_table_association.public["us-east-1b"]: Destroying... [id=rtbassoc-0a44411aed869fdaa]
aws_iam_role_policy.flow_logs[0]: Destroying... [id=prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy]
aws_route.private_default["shared"]: Destroying... [id=r-rtb-0dbfd7a46217d6c521080289494]
aws_default_security_group.this: Destroying... [id=sg-027f4e10d62b9cc99]
aws_default_network_acl.this: Destroying... [id=acl-0852d899abc9011fe]
aws_default_security_group.this: Destruction complete after 1s
aws_default_network_acl.this: Destruction complete after 1s
aws_iam_role_policy.flow_logs[0]: Destruction complete after 1s
aws_flow_log.this[0]: Destruction complete after 1s
aws_cloudwatch_log_group.flow_logs[0]: Destroying... [id=/aws/vpc-flow-log/prd-networking]
aws_iam_role.flow_logs[0]: Destroying... [id=prd-networking-networking-flow-logs-role]
aws_route_table_association.private["us-east-1b"]: Destruction complete after 1s
aws_route_table_association.public["us-east-1a"]: Destruction complete after 1s
aws_route_table_association.private["us-east-1a"]: Destruction complete after 1s
aws_subnet.private["us-east-1a"]: Destroying... [id=subnet-0f9f6bd9df3aab8bf]
aws_subnet.private["us-east-1b"]: Destroying... [id=subnet-0c6fcdfd9dc8b0967]
aws_route_table_association.public["us-east-1b"]: Destruction complete after 1s
aws_route.public_default: Destruction complete after 2s
aws_route.private_default["shared"]: Destruction complete after 2s
aws_nat_gateway.this["us-east-1a"]: Destroying... [id=nat-0767bc502e7e287ef]
aws_route_table.private["shared"]: Destroying... [id=rtb-0dbfd7a46217d6c52]
aws_route_table.public: Destroying... [id=rtb-054316e5b84519b52]
aws_iam_role.flow_logs[0]: Destruction complete after 1s
aws_cloudwatch_log_group.flow_logs[0]: Destruction complete after 1s
aws_subnet.private["us-east-1a"]: Destruction complete after 1s
aws_subnet.private["us-east-1b"]: Destruction complete after 1s
aws_route_table.private["shared"]: Destruction complete after 1s
aws_route_table.public: Destruction complete after 1s
aws_nat_gateway.this["us-east-1a"]: Still destroying... [id=nat-0767bc502e7e287ef, 00m10s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still destroying... [id=nat-0767bc502e7e287ef, 00m20s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still destroying... [id=nat-0767bc502e7e287ef, 00m30s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still destroying... [id=nat-0767bc502e7e287ef, 00m40s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still destroying... [id=nat-0767bc502e7e287ef, 00m50s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still destroying... [id=nat-0767bc502e7e287ef, 01m00s elapsed]
aws_nat_gateway.this["us-east-1a"]: Destruction complete after 1m1s
aws_subnet.public["us-east-1a"]: Destroying... [id=subnet-0ec73e30e5d4a81b3]
aws_eip.nat["us-east-1a"]: Destroying... [id=eipalloc-082634cf000ac13df]
aws_subnet.public["us-east-1b"]: Destroying... [id=subnet-059b33c4972f1f3ca]
aws_subnet.public["us-east-1a"]: Destruction complete after 1s
aws_subnet.public["us-east-1b"]: Destruction complete after 1s
aws_eip.nat["us-east-1a"]: Destruction complete after 1s
aws_internet_gateway.this: Destroying... [id=igw-0f9a35a77f9b9d64d]
aws_internet_gateway.this: Destruction complete after 1s
aws_vpc.this: Destroying... [id=vpc-0b5c9a35a431fd223]
aws_vpc.this: Destruction complete after 1s
Releasing state lock. This may take a few moments...

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
- **Data do apply (UTC):** 2026-08-30T15:37:00Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que aplicou:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do apply

```
aws_cloudwatch_log_group.flow_logs[0]: Creating...
aws_iam_role.flow_logs[0]: Creating...
aws_vpc.this: Creating...
aws_iam_role.flow_logs[0]: Creation complete after 2s [id=prd-networking-networking-flow-logs-role]
aws_cloudwatch_log_group.flow_logs[0]: Creation complete after 7s [id=/aws/vpc-flow-log/prd-networking]
aws_iam_role_policy.flow_logs[0]: Creating...
aws_iam_role_policy.flow_logs[0]: Creation complete after 1s [id=prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy]
aws_vpc.this: Still creating... [00m10s elapsed]
aws_vpc.this: Still creating... [00m20s elapsed]
aws_vpc.this: Creation complete after 21s [id=vpc-0b5c9a35a431fd223]
aws_internet_gateway.this: Creating...
aws_flow_log.this[0]: Creating...
aws_route_table.public: Creating...
aws_route_table.private["shared"]: Creating...
aws_default_security_group.this: Creating...
aws_default_network_acl.this: Creating...
aws_subnet.public["us-east-1a"]: Creating...
aws_subnet.private["us-east-1a"]: Creating...
aws_subnet.private["us-east-1b"]: Creating...
aws_subnet.public["us-east-1b"]: Creating...
aws_flow_log.this[0]: Creation complete after 2s [id=fl-093072eb54747b85f]
aws_route_table.public: Creation complete after 4s [id=rtb-054316e5b84519b52]
aws_internet_gateway.this: Creation complete after 4s [id=igw-0f9a35a77f9b9d64d]
aws_subnet.private["us-east-1b"]: Creation complete after 4s [id=subnet-0c6fcdfd9dc8b0967]
aws_route_table.private["shared"]: Creation complete after 4s [id=rtb-0dbfd7a46217d6c52]
aws_subnet.private["us-east-1a"]: Creation complete after 4s [id=subnet-0f9f6bd9df3aab8bf]
aws_route_table_association.private["us-east-1a"]: Creating...
aws_route_table_association.private["us-east-1b"]: Creating...
aws_route.public_default: Creating...
aws_eip.nat["us-east-1a"]: Creating...
aws_default_security_group.this: Creation complete after 4s [id=sg-027f4e10d62b9cc99]
aws_route_table_association.private["us-east-1a"]: Creation complete after 0s [id=rtbassoc-0ba968f0b2ab6f44f]
aws_route_table_association.private["us-east-1b"]: Creation complete after 1s [id=rtbassoc-0d3d8bbe89201d60c]
aws_default_network_acl.this: Creation complete after 5s [id=acl-0852d899abc9011fe]
aws_route.public_default: Creation complete after 3s [id=r-rtb-054316e5b84519b521080289494]
aws_eip.nat["us-east-1a"]: Creation complete after 4s [id=eipalloc-082634cf000ac13df]
aws_subnet.public["us-east-1a"]: Still creating... [00m10s elapsed]
aws_subnet.public["us-east-1b"]: Still creating... [00m10s elapsed]
aws_subnet.public["us-east-1b"]: Creation complete after 13s [id=subnet-059b33c4972f1f3ca]
aws_subnet.public["us-east-1a"]: Creation complete after 13s [id=subnet-0ec73e30e5d4a81b3]
aws_route_table_association.public["us-east-1a"]: Creating...
aws_route_table_association.public["us-east-1b"]: Creating...
aws_nat_gateway.this["us-east-1a"]: Creating...
aws_route_table_association.public["us-east-1b"]: Creation complete after 1s [id=rtbassoc-0a44411aed869fdaa]
aws_route_table_association.public["us-east-1a"]: Creation complete after 1s [id=rtbassoc-09b5d8b972a406992]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m10s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m20s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m30s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m40s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m50s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m00s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m10s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m20s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m30s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m40s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m50s elapsed]
aws_nat_gateway.this["us-east-1a"]: Creation complete after 1m51s [id=nat-0767bc502e7e287ef]
aws_route.private_default["shared"]: Creating...
aws_route.private_default["shared"]: Creation complete after 1s [id=r-rtb-0dbfd7a46217d6c521080289494]
Releasing state lock. This may take a few moments...

Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

internet_gateway_id = "igw-0f9a35a77f9b9d64d"
nat_gateway_ids = [
  "nat-0767bc502e7e287ef",
]
nat_gateway_public_ips = [
  "3.220.58.118",
]
private_route_tables_ids = [
  "rtb-0dbfd7a46217d6c52",
]
private_subnets_ids = [
  "subnet-0f9f6bd9df3aab8bf",
  "subnet-0c6fcdfd9dc8b0967",
]
public_route_tables_ids = [
  "rtb-054316e5b84519b52",
]
public_subnets_ids = [
  "subnet-0ec73e30e5d4a81b3",
  "subnet-059b33c4972f1f3ca",
]
vpc_availability_zones = tolist([
  "us-east-1a",
  "us-east-1b",
])
vpc_cidr_block = "10.0.0.0/24"
vpc_id = "vpc-0b5c9a35a431fd223"
```

## Outputs

```json
{
  "internet_gateway_id": {
    "sensitive": false,
    "type": "string",
    "value": "igw-0f9a35a77f9b9d64d"
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
      "nat-0767bc502e7e287ef"
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
      "3.220.58.118"
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
      "rtb-0dbfd7a46217d6c52"
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
      "subnet-0f9f6bd9df3aab8bf",
      "subnet-0c6fcdfd9dc8b0967"
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
      "rtb-054316e5b84519b52"
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
      "subnet-0ec73e30e5d4a81b3",
      "subnet-059b33c4972f1f3ca"
    ]
  },
  "vpc_availability_zones": {
    "sensitive": false,
    "type": [
      "list",
      "string"
    ],
    "value": [
      "us-east-1a",
      "us-east-1b"
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
    "value": "vpc-0b5c9a35a431fd223"
  }
}
```

## Recursos no state

```
data.aws_availability_zones.available
aws_cloudwatch_log_group.flow_logs[0]
aws_default_network_acl.this
aws_default_security_group.this
aws_eip.nat["us-east-1a"]
aws_flow_log.this[0]
aws_iam_role.flow_logs[0]
aws_iam_role_policy.flow_logs[0]
aws_internet_gateway.this
aws_nat_gateway.this["us-east-1a"]
aws_route.private_default["shared"]
aws_route.public_default
aws_route_table.private["shared"]
aws_route_table.public
aws_route_table_association.private["us-east-1a"]
aws_route_table_association.private["us-east-1b"]
aws_route_table_association.public["us-east-1a"]
aws_route_table_association.public["us-east-1b"]
aws_subnet.private["us-east-1a"]
aws_subnet.private["us-east-1b"]
aws_subnet.public["us-east-1a"]
aws_subnet.public["us-east-1b"]
aws_vpc.this
```
