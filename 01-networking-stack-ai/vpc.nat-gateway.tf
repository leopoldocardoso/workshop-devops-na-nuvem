############################################################################
# vpc.nat-gateway.tf
#
# ADR-0001 (Secao 13.1 passo 11 / Secao 6.2): aws_eip + aws_nat_gateway.
#
# Arquivo desdobrado de routing.tf (regra
# .claude/rules/terraform-naming-conventions.md, Secao 2) — nenhuma mudanca
# de comportamento em relacao ao ADR-0001.
############################################################################

# --------------------------------------------------------------------------
# Elastic IP(s) do NAT Gateway: NAT unico compartilhado (1 EIP) e, a partir
# da Revisao 5 do ADR-0001 (Premissa 14), a configuracao fixa e definitiva
# do unico ambiente desta stack (prd). A flag one_nat_gateway_per_az
# permanece funcional no codigo (1 EIP por AZ) apenas como caminho de
# reversao futura para HA, caso a postura de risco mude (ADR-0001
# Secao 11/12); nao utilizada nesta revisao.
# --------------------------------------------------------------------------
resource "aws_eip" "nat" {
  for_each = toset(local.nat_gateway_azs)

  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-nat-eip-${each.key}"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  for_each = toset(local.nat_gateway_azs)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-nat-${each.key}"
  })

  depends_on = [aws_internet_gateway.this]
}
