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
