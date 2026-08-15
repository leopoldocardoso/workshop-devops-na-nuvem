############################################################################
# data.tf
#
# ADR-0002 (Secao 6.2, linha "Account ID atual" / Secao 4, decisao D2):
# resolve o Account ID da conta atual, usado para compor o nome globalmente
# unico do bucket de state (locals.tf), evitando dependencia do provider
# hashicorp/random para geracao de sufixo aleatorio.
############################################################################

data "aws_caller_identity" "current" {}
