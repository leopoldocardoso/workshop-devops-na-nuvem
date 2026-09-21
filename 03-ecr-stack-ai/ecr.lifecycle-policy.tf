############################################################################
# ecr.lifecycle-policy.tf
#
# ADR-0004 (Secao 4/D4, Secao 6.2, 13.1 passo 2): uma lifecycle policy por
# repositorio, com as mesmas 2 regras (documento em local.lifecycle_policy):
#   1. expira imagens nao tageadas com mais de N dias;
#   2. mantem apenas as N imagens tageadas mais recentes.
#
# Referencia `.name` do repositorio ja criado — dependencia implicita,
# garante a ordem repositorio -> lifecycle policy. Apenas UMA
# aws_ecr_lifecycle_policy por repositorio e permitida pela API; regras
# adicionais devem ser combinadas no mesmo documento JSON.
############################################################################

resource "aws_ecr_lifecycle_policy" "frontend" {
  repository = aws_ecr_repository.frontend.name
  policy     = local.lifecycle_policy
}

resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.backend.name
  policy     = local.lifecycle_policy
}
