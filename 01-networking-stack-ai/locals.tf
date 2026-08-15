############################################################################
# locals.tf
#
# ADR-0001 (Secao 13.1 passo 8): nomes padronizados, tags comuns e calculo
# dos blocos CIDR das sub-redes via cidrsubnet().
#
# Atualizado na Revisao 4 do ADR-0001 (Secao 13.1 passo 2): CIDR da VPC
# 192.168.1.0/24 -> 10.0.0.0/24 e particionamento de 4x /27 (metade do
# bloco, com reserva) para 4x /26 (100% do bloco, sem reserva).
#
# Atualizado na Revisao 5 do ADR-0001 (Secao 4, decisao D2 / Secao 13.1
# passo 4): a stack passa a suportar um unico ambiente ("prd"); a antiga
# variable "environment" foi removida de variables.tf e substituida pelo
# local "environment" abaixo, fixo em "prd" — nao mais um input livre.
############################################################################

locals {
  # Ambiente unico e definitivo desta stack a partir da Revisao 5 do
  # ADR-0001 (Secao 4, decisao D2). Nao e mais um input Terraform: fixar
  # este valor aqui elimina a possibilidade de aplicar a stack contra
  # qualquer outro nome de ambiente sem uma mudanca de codigo consciente.
  environment = "prd"

  # Prefixo de naming convention: {env}-{project_name}
  # (ADR-0001 Secao 9: "{env}-{project_name}-{service}-{region}")
  name = "${local.environment}-${var.project_name}"

  # AZs efetivamente utilizadas pela stack: usa var.vpc.availability_zones se
  # informado explicitamente; caso contrario, resolve dinamicamente as 2
  # primeiras AZs disponiveis na regiao (ADR-0001 Premissa 3: 2 AZs nesta
  # primeira versao).
  azs = length(var.vpc.availability_zones) > 0 ? var.vpc.availability_zones : slice(data.aws_availability_zones.available.names, 0, 2)

  # --------------------------------------------------------------------
  # Tags obrigatorias (ADR-0001, Secao 9). Aplicadas via default_tags do
  # provider (providers.tf) E reforcadas individualmente em cada recurso
  # nativo (merge(local.common_tags, { Name = "..." })), conforme decisao
  # explicita do ADR de nao depender de modulo para garantir cobertura.
  #
  # ATENCAO: 'Owner' e 'CostCenter' nao possuem valor definitivo no
  # ADR-0001 ("a definir pelo solicitante" — Secao 9). Os placeholders
  # abaixo DEVEM ser sobrescritos via var.tags (terraform.tfvars, na raiz
  # da stack) antes do apply. Ver README.md > Pontos de Atencao.
  # --------------------------------------------------------------------
  common_tags = merge(
    {
      Environment        = local.environment
      Owner              = "unassigned"
      CostCenter         = "unassigned"
      Project            = var.project_name
      ManagedBy          = "terraform"
      DataClassification = "internal"
      StackName          = "01-networking-stack-ai"
    },
    var.tags
  )

  # --------------------------------------------------------------------
  # Plano de enderecamento (ADR-0001 Revisao 4, Secao 6.2 / 13.1).
  #
  # var.vpc.cidr (10.0.0.0/24) e dividido em 4 blocos /26 via
  # cidrsubnet(cidr, 2, index), indices 0-3, ocupando 100% do /24
  # (256 IPs), sem bloco reservado:
  #   index 0 -> 10.0.0.0/26    (publica AZ1)
  #   index 1 -> 10.0.0.64/26   (publica AZ2)
  #   index 2 -> 10.0.0.128/26  (privada AZ1)
  #   index 3 -> 10.0.0.192/26  (privada AZ2)
  #
  # Nao ha mais bloco reservado para expansao futura (o desenho anterior
  # reservava 192.168.1.128/25, nao utilizado). O local 'reserved_cidr_block'
  # foi removido nesta revisao — expansao futura deste CIDR primario exige
  # um CIDR IPv4 secundario associado a VPC
  # (aws_vpc_ipv4_cidr_block_association), a avaliar em ADR proprio
  # (ADR-0001 Secao 11 / 14).
  # --------------------------------------------------------------------

  public_subnet_cidrs = {
    (local.azs[0]) = cidrsubnet(var.vpc.cidr, 2, 0) # 10.0.0.0/26
    (local.azs[1]) = cidrsubnet(var.vpc.cidr, 2, 1) # 10.0.0.64/26
  }

  private_subnet_cidrs = {
    (local.azs[0]) = cidrsubnet(var.vpc.cidr, 2, 2) # 10.0.0.128/26
    (local.azs[1]) = cidrsubnet(var.vpc.cidr, 2, 3) # 10.0.0.192/26
  }

  # --------------------------------------------------------------------
  # Estrategia de NAT Gateway (ADR-0001, Secao 6.2 / 13.2):
  #   - nat_gateway.enabled = false               -> nenhum NAT Gateway/EIP
  #                                                   criado.
  #   - nat_gateway.one_nat_gateway_per_az = true -> 1 NAT Gateway por AZ (HA
  #                                        plena; 2 no total com as 2 AZs
  #                                        desta versao). Mantido no codigo
  #                                        apenas como caminho de reversao
  #                                        futura (ADR-0001 Secao 11/12) —
  #                                        nao utilizado nesta revisao.
  #   - caso contrario (configuracao fixa e definitiva do unico ambiente
  #     desta stack, prd, a partir da Revisao 5 — ADR-0001 Premissa 14)
  #     -> 1 NAT Gateway compartilhado, criado na 1a AZ.
  #
  # 'nat_gateway.single_nat_gateway' e mantido como atributo dedicado por
  # exigencia da Secao 13.2 do ADR (paridade semantica/documentacional
  # com a tabela de variaveis); a multiplicidade efetiva de recursos e
  # determinada por 'nat_gateway.one_nat_gateway_per_az', conforme descrito
  # na tabela de recursos da Secao 6.2.
  # --------------------------------------------------------------------
  nat_gateway_azs = var.nat_gateway.enabled ? (var.nat_gateway.one_nat_gateway_per_az ? local.azs : [local.azs[0]]) : []

  # Chaves das tabelas de rota privadas: 1 por AZ (HA,
  # nat_gateway.one_nat_gateway_per_az = true, caminho de reversao futura
  # nao utilizado nesta revisao) ou uma unica tabela compartilhada (chave
  # fixa "shared"), configuracao definitiva do unico ambiente desta stack
  # (prd) a partir da Revisao 5 do ADR-0001 (Premissa 14).
  private_route_table_keys = var.nat_gateway.one_nat_gateway_per_az ? local.azs : ["shared"]
}
