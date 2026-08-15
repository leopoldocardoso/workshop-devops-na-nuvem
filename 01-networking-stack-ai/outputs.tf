############################################################################
# outputs.tf
#
# ADR-0001 (Secao 13.1 passo 13 / Secao 13.3): outputs consumidos por stacks
# futuras (ex.: 02-compute-stack) via terraform_remote_state ou SSM
# Parameter Store.
#
# Nomes ajustados ao padrao {name}_{type}_{attribute} (regra
# .claude/rules/terraform-naming-conventions.md, Secao 5) — apenas
# identificadores renomeados; valores e semantica identicos ao ADR-0001.
############################################################################

output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR da VPC (10.0.0.0/24)."
  value       = aws_vpc.this.cidr_block
}

output "public_subnets_ids" {
  description = "Lista de IDs das sub-redes publicas."
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnets_ids" {
  description = "Lista de IDs das sub-redes privadas."
  value       = [for s in aws_subnet.private : s.id]
}

output "public_route_tables_ids" {
  description = "IDs das tabelas de rota publicas."
  value       = [aws_route_table.public.id]
}

output "private_route_tables_ids" {
  description = "IDs das tabelas de rota privadas."
  value       = [for rt in aws_route_table.private : rt.id]
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_ids" {
  description = "IDs do(s) NAT Gateway(s) criado(s)."
  value       = [for nat in aws_nat_gateway.this : nat.id]
}

output "nat_gateway_public_ips" {
  description = "IP(s) publico(s) do(s) NAT Gateway(s) (util para allowlisting em servicos externos)."
  value       = [for nat in aws_nat_gateway.this : nat.public_ip]
}

output "vpc_availability_zones" {
  description = "Lista das AZs efetivamente utilizadas pela stack."
  value       = local.azs
}
