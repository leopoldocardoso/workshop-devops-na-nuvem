############################################################################
# data.tf
#
# ADR-0003 (Secao 4, decisao D4 / Secao 6.2 / 13.1 passo 1): consumo da
# VPC e das sub-redes de 01-networking-stack-ai via data sources nativos
# filtrados por tag — NAO via terraform_remote_state (decisao explicita do
# ADR, ver justificativa na Secao 4/D4: desacoplada de onde/como o state
# daquela stack e armazenado).
#
# As tags usadas nos filtros abaixo (StackName, Environment, Tier) sao
# aplicadas em 100% dos recursos de 01-networking-stack-ai via
# local.common_tags (confirmado por leitura de
# 01-networking-stack-ai/vpc.tf, vpc.public-subnets.tf e
# vpc.private-subnets.tf nesta sessao).
############################################################################

data "aws_vpc" "networking" {
  filter {
    name   = "tag:StackName"
    values = [var.networking.stack_name]
  }

  filter {
    name   = "tag:Environment"
    values = [var.networking.environment]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.networking.id]
  }

  filter {
    name   = "tag:StackName"
    values = [var.networking.stack_name]
  }

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.networking.id]
  }

  filter {
    name   = "tag:StackName"
    values = [var.networking.stack_name]
  }

  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
}

data "aws_caller_identity" "current" {}
