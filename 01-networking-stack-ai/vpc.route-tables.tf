############################################################################
# vpc.route-tables.tf
#
# ADR-0001 (Secao 13.1 passo 11 / Secao 6.2): aws_internet_gateway,
# aws_route_table, aws_route e aws_route_table_association.
#
# O Internet Gateway e mantido neste arquivo (e nao em vpc.nat-gateway.tf):
# a regra .claude/rules/terraform-naming-conventions.md nao define um
# arquivo de dominio dedicado para IGW, e o IGW e referenciado exclusivamente
# pela rota default da tabela publica abaixo — portanto pertence ao dominio
# "route-tables" (destino de rota), nao ao dominio "nat-gateway".
#
# Rotas default sao recursos aws_route separados (nao inline em
# aws_route_table), conforme decisao explicita do ADR para evitar conflito
# de gerenciamento de estado.
#
# Arquivo desdobrado de routing.tf (regra, Secao 2) — nenhuma mudanca de
# comportamento em relacao ao ADR-0001.
############################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-igw-${var.aws_region}"
  })
}

# --------------------------------------------------------------------------
# Tabela de rotas publica: 1 tabela, compartilhada pelas 2 sub-redes publicas.
# --------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-rt-public-${var.aws_region}"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# --------------------------------------------------------------------------
# Tabela(s) de rotas privada(s): 1 compartilhada (chave "shared") e, a
# partir da Revisao 5 do ADR-0001 (Premissa 14), a configuracao fixa e
# definitiva do unico ambiente desta stack (prd). A alternativa de 1 tabela
# por AZ (var.nat_gateway.one_nat_gateway_per_az = true) permanece
# funcional no codigo apenas como caminho de reversao futura para HA
# (ADR-0001 Secao 11/12); nao utilizada nesta revisao.
# --------------------------------------------------------------------------
resource "aws_route_table" "private" {
  for_each = toset(local.private_route_table_keys)

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = var.nat_gateway.one_nat_gateway_per_az ? "${local.name}-networking-rt-private-${each.key}" : "${local.name}-networking-rt-private-${var.aws_region}"
  })
}

# Rota default privada -> NAT Gateway correspondente. So e criada quando
# var.nat_gateway.enabled = true (sem NAT nao ha destino valido para a rota).
resource "aws_route" "private_default" {
  for_each = var.nat_gateway.enabled ? aws_route_table.private : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway.one_nat_gateway_per_az ? aws_nat_gateway.this[each.key].id : aws_nat_gateway.this[local.azs[0]].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = var.nat_gateway.one_nat_gateway_per_az ? aws_route_table.private[each.key].id : aws_route_table.private["shared"].id
}
