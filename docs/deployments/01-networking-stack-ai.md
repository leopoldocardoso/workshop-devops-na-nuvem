# Deployment: 01-networking-stack-ai

> Gerado automaticamente por `.claude/skills/terraform-deploy/deploy.sh`
> apos `terraform apply -auto-approve`. Nao editar manualmente —
> este arquivo e sobrescrito no proximo deploy desta stack.

- **Stack:** `01-networking-stack-ai`
- **Data do apply (UTC):** 2026-08-29T00:50:57Z
- **Terraform:** Terraform v1.15.8
- **Identidade AWS que aplicou:** 659942169599	arn:aws:iam::659942169599:user/atlantis

## Resultado do apply

```
aws_vpc.this: Creating...
aws_cloudwatch_log_group.flow_logs[0]: Creating...
aws_iam_role.flow_logs[0]: Creating...
aws_cloudwatch_log_group.flow_logs[0]: Creation complete after 0s [id=/aws/vpc-flow-log/prd-networking]
aws_iam_role.flow_logs[0]: Creation complete after 1s [id=prd-networking-networking-flow-logs-role]
aws_iam_role_policy.flow_logs[0]: Creating...
aws_iam_role_policy.flow_logs[0]: Creation complete after 0s [id=prd-networking-networking-flow-logs-role:prd-networking-networking-flow-logs-policy]
aws_vpc.this: Creation complete after 2s [id=vpc-0088134b2dc45d03f]
aws_internet_gateway.this: Creating...
aws_subnet.public["sa-east-1a"]: Creating...
aws_route_table.private["shared"]: Creating...
aws_route_table.public: Creating...
aws_flow_log.this[0]: Creating...
aws_default_security_group.this: Creating...
aws_subnet.public["sa-east-1b"]: Creating...
aws_subnet.private["sa-east-1b"]: Creating...
aws_subnet.private["sa-east-1a"]: Creating...
aws_default_network_acl.this: Creating...
aws_flow_log.this[0]: Creation complete after 1s [id=fl-0921f7703f6aa015a]
aws_internet_gateway.this: Creation complete after 1s [id=igw-00263a8f36b794b83]
aws_eip.nat["sa-east-1a"]: Creating...
aws_route_table.private["shared"]: Creation complete after 1s [id=rtb-0903d54548fb2d5a4]
aws_route_table.public: Creation complete after 1s [id=rtb-04ed9681bb998bfd1]
aws_route.public_default: Creating...
aws_subnet.private["sa-east-1a"]: Creation complete after 1s [id=subnet-02c6741636723ba8e]
aws_default_network_acl.this: Creation complete after 2s [id=acl-0a62dd4db742c9689]
aws_eip.nat["sa-east-1a"]: Creation complete after 1s [id=eipalloc-03b4b274eb8138974]
aws_route.public_default: Creation complete after 1s [id=r-rtb-04ed9681bb998bfd11080289494]
aws_default_security_group.this: Creation complete after 3s [id=sg-048560e0fb3c5d8d1]
aws_subnet.private["sa-east-1b"]: Creation complete after 5s [id=subnet-0507ff42e6e13d1e7]
aws_route_table_association.private["sa-east-1b"]: Creating...
aws_route_table_association.private["sa-east-1a"]: Creating...
aws_route_table_association.private["sa-east-1b"]: Creation complete after 1s [id=rtbassoc-0e7f65f0a0833728c]
aws_route_table_association.private["sa-east-1a"]: Creation complete after 1s [id=rtbassoc-02f76c2faa4fafb71]
aws_subnet.public["sa-east-1b"]: Still creating... [00m10s elapsed]
aws_subnet.public["sa-east-1a"]: Still creating... [00m10s elapsed]
aws_subnet.public["sa-east-1a"]: Creation complete after 12s [id=subnet-0d67b260198bc296b]
aws_subnet.public["sa-east-1b"]: Creation complete after 12s [id=subnet-0e5b28639b4d8f4b3]
aws_route_table_association.public["sa-east-1a"]: Creating...
aws_route_table_association.public["sa-east-1b"]: Creating...
aws_nat_gateway.this["sa-east-1a"]: Creating...
aws_route_table_association.public["sa-east-1b"]: Creation complete after 0s [id=rtbassoc-00e6a2559d74f0273]
aws_route_table_association.public["sa-east-1a"]: Creation complete after 0s [id=rtbassoc-0215a27ffc41dfe65]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m10s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m20s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m30s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m40s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [00m50s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Still creating... [01m00s elapsed]
aws_nat_gateway.this["sa-east-1a"]: Creation complete after 1m4s [id=nat-0b7164c8c9f32f8dc]
aws_route.private_default["shared"]: Creating...
aws_route.private_default["shared"]: Creation complete after 1s [id=r-rtb-0903d54548fb2d5a41080289494]

Apply complete! Resources: 22 added, 0 changed, 0 destroyed.

Outputs:

internet_gateway_id = "igw-00263a8f36b794b83"
nat_gateway_ids = [
  "nat-0b7164c8c9f32f8dc",
]
nat_gateway_public_ips = [
  "54.232.74.230",
]
private_route_tables_ids = [
  "rtb-0903d54548fb2d5a4",
]
private_subnets_ids = [
  "subnet-02c6741636723ba8e",
  "subnet-0507ff42e6e13d1e7",
]
public_route_tables_ids = [
  "rtb-04ed9681bb998bfd1",
]
public_subnets_ids = [
  "subnet-0d67b260198bc296b",
  "subnet-0e5b28639b4d8f4b3",
]
vpc_availability_zones = tolist([
  "sa-east-1a",
  "sa-east-1b",
])
vpc_cidr_block = "10.0.0.0/24"
vpc_id = "vpc-0088134b2dc45d03f"
```

## Outputs

```json
{
  "internet_gateway_id": {
    "sensitive": false,
    "type": "string",
    "value": "igw-00263a8f36b794b83"
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
      "nat-0b7164c8c9f32f8dc"
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
      "54.232.74.230"
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
      "rtb-0903d54548fb2d5a4"
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
      "subnet-02c6741636723ba8e",
      "subnet-0507ff42e6e13d1e7"
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
      "rtb-04ed9681bb998bfd1"
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
      "subnet-0d67b260198bc296b",
      "subnet-0e5b28639b4d8f4b3"
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
    "value": "vpc-0088134b2dc45d03f"
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
