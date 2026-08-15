############################################################################
# vpc.public-subnets.tf
#
# ADR-0001 (Secao 13.1 passo 10 / Secao 6.2): 2 aws_subnet publicas, uma por
# AZ, usando os blocos /27 calculados em locals.tf.
#
# Arquivo desdobrado de subnets.tf (regra
# .claude/rules/terraform-naming-conventions.md, Secao 2) — nenhuma mudanca
# de comportamento em relacao ao ADR-0001.
############################################################################

resource "aws_subnet" "public" {
  for_each = local.public_subnet_cidrs

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-public-${each.key}"
    Tier = "public"
  })
}
