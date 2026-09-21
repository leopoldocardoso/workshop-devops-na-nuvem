############################################################################
# ecr.tf
#
# ADR-0004 (Secao 6.2 / 13.1 passo 2): os dois repositorios ECR privados.
#   - name: path-style literal do pedido (local.repository_names) — D1.
#   - encryption_configuration: AES256, chave gerenciada pela AWS — D2.
#   - image_tag_mutability: IMMUTABLE_WITH_EXCLUSION, com excecao para
#     tags que casem com `latest*` (unico padrao de tag sobrescrevivel;
#     qualquer outra tag e protegida contra sobrescrita) — D3.
#   - image_scanning_configuration.scan_on_push: scanning basico — Secao 8.
#   - force_delete: default (false) — o repositorio NAO pode ser destruido
#     enquanto contiver imagens (ADR-0004 Secao 12). Nunca definir
#     force_delete = true sem confirmacao explicita em sessao.
#
# Nenhuma aws_ecr_repository_policy e criada: repositorios permanecem
# privados, sem acesso cross-account (ADR-0004 Secao 8 / 14).
############################################################################

resource "aws_ecr_repository" "frontend" {
  name                 = local.repository_names.frontend
  image_tag_mutability = var.ecr.image_tag_mutability

  image_tag_mutability_exclusion_filter {
    filter      = var.ecr.image_tag_mutability_exclusion_filter
    filter_type = "WILDCARD"
  }

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.ecr.encryption_type
  }

  tags = merge(local.common_tags, {
    Name        = local.repository_names.frontend
    Application = "frontend"
  })
}

resource "aws_ecr_repository" "backend" {
  name                 = local.repository_names.backend
  image_tag_mutability = var.ecr.image_tag_mutability

  image_tag_mutability_exclusion_filter {
    filter      = var.ecr.image_tag_mutability_exclusion_filter
    filter_type = "WILDCARD"
  }

  image_scanning_configuration {
    scan_on_push = var.ecr.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.ecr.encryption_type
  }

  tags = merge(local.common_tags, {
    Name        = local.repository_names.backend
    Application = "backend"
  })
}
