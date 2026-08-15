############################################################################
# main.tf
#
# Ponto de entrada da stack 01-networking-stack-ai (ADR-0001).
#
# Esta stack nao usa blocos `module` (ADR-0001 Secao 5 / 13.1) — todos os
# recursos sao nativos do provider hashicorp/aws, organizados em arquivos
# por dominio (regra .claude/rules/terraform-naming-conventions.md, Secao 2).
# Este arquivo nao declara recursos; serve apenas como indice de onde cada
# dominio esta implementado:
#
#   versions.tf                 -> Terraform CLI + provider hashicorp/aws.
#   backend.tf                  -> backend S3 (configuracao parcial).
#   providers.tf                -> provider "aws" + default_tags.
#   variables.tf                -> variaveis de input (sem default).
#   data.tf                     -> data source de Availability Zones.
#   locals.tf                   -> naming, tags comuns, calculo de CIDRs.
#   vpc.tf                      -> aws_vpc + adocao de SG/NACL default.
#   vpc.public-subnets.tf       -> sub-redes publicas.
#   vpc.private-subnets.tf      -> sub-redes privadas.
#   vpc.route-tables.tf         -> Internet Gateway, route tables, rotas e
#                                   associacoes.
#   vpc.nat-gateway.tf          -> Elastic IP(s) e NAT Gateway(s).
#   vpc.flow-logs.tf            -> VPC Flow Logs (IAM role/policy, log
#                                   group, aws_flow_log).
#   outputs.tf                  -> outputs consumidos por stacks futuras.
############################################################################
