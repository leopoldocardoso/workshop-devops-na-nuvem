############################################################################
# data.tf
#
# ADR-0001 (Secao 13.1 passo 7 / Secao 6.2, linha "Data source de AZs"):
# resolve dinamicamente as Availability Zones disponiveis na regiao, evitando
# hardcode de nomes de AZ (ex.: "sa-east-1a") diretamente no codigo.
############################################################################

data "aws_availability_zones" "available" {
  state = "available"
}
