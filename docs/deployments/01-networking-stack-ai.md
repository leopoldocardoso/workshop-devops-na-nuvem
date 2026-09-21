# Deployment: 01-networking-stack-ai

> Gerado automaticamente por `.claude/skills/terraform-deploy/deploy.sh`
> apos `terraform apply -auto-approve`. Nao editar manualmente —
> este arquivo e sobrescrito no proximo deploy desta stack.

- **Stack:** `01-networking-stack-ai`
- **Data do apply (UTC):** 2026-09-21T13:14:11Z
- **Terraform:** Terraform v1.16.0
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
aws_vpc.this: Creation complete after 3s [id=vpc-0882c8ebd4a1d9e97]
aws_route_table.public: Creating...
aws_internet_gateway.this: Creating...
aws_flow_log.this[0]: Creating...
aws_subnet.private["us-east-1a"]: Creating...
aws_default_security_group.this: Creating...
aws_route_table.private["shared"]: Creating...
aws_subnet.public["us-east-1a"]: Creating...
aws_subnet.public["us-east-1b"]: Creating...
aws_default_network_acl.this: Creating...
aws_subnet.private["us-east-1b"]: Creating...
aws_flow_log.this[0]: Creation complete after 1s [id=fl-0277108fb8dd2108c]
aws_internet_gateway.this: Creation complete after 1s [id=igw-09418774f87f2df3d]
aws_eip.nat["us-east-1a"]: Creating...
aws_route_table.public: Creation complete after 2s [id=rtb-06ba578d5edc3dd74]
aws_route.public_default: Creating...
aws_route_table.private["shared"]: Creation complete after 2s [id=rtb-0b1e885b688f666a9]
aws_subnet.private["us-east-1b"]: Creation complete after 2s [id=subnet-0ca8fdd7f7235d180]
aws_default_network_acl.this: Creation complete after 2s [id=acl-058c06de307539784]
aws_route.public_default: Creation complete after 1s [id=r-rtb-06ba578d5edc3dd741080289494]
aws_default_security_group.this: Creation complete after 3s [id=sg-0450baa1158a984bd]
aws_eip.nat["us-east-1a"]: Creation complete after 3s [id=eipalloc-01b9acb97442f2e71]
aws_subnet.private["us-east-1a"]: Creation complete after 4s [id=subnet-0bad2fdc9d281c06a]
aws_route_table_association.private["us-east-1b"]: Creating...
aws_route_table_association.private["us-east-1a"]: Creating...
aws_route_table_association.private["us-east-1b"]: Creation complete after 1s [id=rtbassoc-0913dd48f0847d620]
aws_route_table_association.private["us-east-1a"]: Creation complete after 1s [id=rtbassoc-07762b1fee36936b3]
aws_subnet.public["us-east-1a"]: Still creating... [00m10s elapsed]
aws_subnet.public["us-east-1b"]: Still creating... [00m10s elapsed]
aws_subnet.public["us-east-1a"]: Creation complete after 12s [id=subnet-0371b3b114f3a204b]
aws_subnet.public["us-east-1b"]: Creation complete after 15s [id=subnet-04d5956cb61b4689d]
aws_route_table_association.public["us-east-1b"]: Creating...
aws_route_table_association.public["us-east-1a"]: Creating...
aws_nat_gateway.this["us-east-1a"]: Creating...
aws_route_table_association.public["us-east-1a"]: Creation complete after 0s [id=rtbassoc-00191256fbee66925]
aws_route_table_association.public["us-east-1b"]: Creation complete after 0s [id=rtbassoc-030121e7e3c75c363]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m10s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m20s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m30s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m40s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [00m50s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m00s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m10s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m20s elapsed]
aws_nat_gateway.this["us-east-1a"]: Still creating... [01m30s elapsed]
aws_nat_gateway.this["us-east-1a"]: Creation complete after 1m35s [id=nat-04b1ba9eb70357c16]
aws_route.private_default["shared"]: Creating...
aws_route.private_default["shared"]: Creation complete after 1s [id=r-rtb-0b1e885b688f666a91080289494]

Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

internet_gateway_id = "igw-09418774f87f2df3d"
nat_gateway_ids = [
  "nat-04b1ba9eb70357c16",
]
nat_gateway_public_ips = [
  "52.86.87.152",
]
private_route_tables_ids = [
  "rtb-0b1e885b688f666a9",
]
private_subnets_ids = [
  "subnet-0bad2fdc9d281c06a",
  "subnet-0ca8fdd7f7235d180",
]
public_route_tables_ids = [
  "rtb-06ba578d5edc3dd74",
]
public_subnets_ids = [
  "subnet-0371b3b114f3a204b",
  "subnet-04d5956cb61b4689d",
]
vpc_availability_zones = tolist([
  "us-east-1a",
  "us-east-1b",
])
vpc_cidr_block = "10.0.0.0/24"
vpc_id = "vpc-0882c8ebd4a1d9e97"
```

## Outputs

```json
{
  "internet_gateway_id": {
    "sensitive": false,
    "type": "string",
    "value": "igw-09418774f87f2df3d"
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
      "nat-04b1ba9eb70357c16"
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
      "52.86.87.152"
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
      "rtb-0b1e885b688f666a9"
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
      "subnet-0bad2fdc9d281c06a",
      "subnet-0ca8fdd7f7235d180"
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
      "rtb-06ba578d5edc3dd74"
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
      "subnet-0371b3b114f3a204b",
      "subnet-04d5956cb61b4689d"
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
    "value": "vpc-0882c8ebd4a1d9e97"
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
