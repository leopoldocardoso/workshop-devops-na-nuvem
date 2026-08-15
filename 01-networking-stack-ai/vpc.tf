############################################################################
# vpc.tf
#
# ADR-0001 (Secao 13.1 passo 9 / Secao 6.2): aws_vpc, aws_default_security_group
# e aws_default_network_acl (recursos de "adocao" dos objetos default criados
# automaticamente pela AWS junto com a VPC).
############################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-vpc-${var.aws_region}"
  })
}

# --------------------------------------------------------------------------
# Default Security Group: adotado explicitamente sem nenhuma regra de
# ingress/egress (least privilege por padrao — ADR-0001 Secao 6.2/8).
# Nenhum bloco ingress/egress e declarado, removendo TODAS as regras que a
# AWS cria por padrao (que incluiriam allow-all self em ingress e
# 0.0.0.0/0 em egress).
# --------------------------------------------------------------------------
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-default-sg"
  })
}

# --------------------------------------------------------------------------
# Default Network ACL: adotada explicitamente, mantida no padrao allow-all
# (replicando o comportamento default da AWS), conforme decisao do ADR-0001
# (Secao 6.2: "mantida no padrao allow-all nesta fase (documentar como ponto
# de evolucao; ver Secao 14)"). NACLs dedicadas por sub-rede sao Non-goal
# explicito desta stack (Secao 14).
#
# subnet_ids nao e gerenciado explicitamente aqui (lifecycle.ignore_changes)
# para evitar diffs recorrentes: as sub-redes criadas em subnets.tf sao
# associadas automaticamente a esta NACL default pela propria AWS, por nao
# especificarem um network_acl_id proprio.
# --------------------------------------------------------------------------
resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-default-nacl"
  })

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}
