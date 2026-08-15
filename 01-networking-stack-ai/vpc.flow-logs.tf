############################################################################
# vpc.flow-logs.tf
#
# ADR-0001 (Secao 13.1 passo 12 / Secao 6.2 / Secao 8): VPC Flow Logs com
# destino CloudWatch Logs, role IAM de escopo minimo (least privilege),
# restrita ao ARN do log group especifico desta stack.
#
# Arquivo renomeado de flow_logs.tf (regra
# .claude/rules/terraform-naming-conventions.md, Secao 2) — nenhuma mudanca
# de comportamento em relacao ao ADR-0001.
############################################################################

# --------------------------------------------------------------------------
# IAM Role de Flow Logs: trust policy restrita ao principal de servico
# vpc-flow-logs.amazonaws.com.
# --------------------------------------------------------------------------
resource "aws_iam_role" "flow_logs" {
  count = var.flow_logs.enabled ? 1 : 0

  name = "${local.name}-networking-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-flow-logs-role"
  })
}

# --------------------------------------------------------------------------
# CloudWatch Log Group de destino dos Flow Logs. Criptografia em repouso via
# chave gerenciada pela AWS por padrao (ADR-0001 Secao 8) — nenhuma CMK
# dedicada e exigida neste ciclo (nenhum requisito de compliance informado).
# --------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.flow_logs.enabled ? 1 : 0

  name              = "/aws/vpc-flow-log/${local.name}"
  retention_in_days = var.flow_logs.retention_days

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-flow-log-group"
  })
}

# --------------------------------------------------------------------------
# Policy inline de escopo minimo (least privilege): apenas as acoes
# estritamente necessarias para entrega de Flow Logs, escopadas ao ARN do
# log group especifico desta stack — nunca Resource "*" ou Action "logs:*"
# (ADR-0001 Secao 8).
# --------------------------------------------------------------------------
resource "aws_iam_role_policy" "flow_logs" {
  count = var.flow_logs.enabled ? 1 : 0

  name = "${local.name}-networking-flow-logs-policy"
  role = aws_iam_role.flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ]
        Resource = "${aws_cloudwatch_log_group.flow_logs[0].arn}:*"
      }
    ]
  })
}

resource "aws_flow_log" "this" {
  count = var.flow_logs.enabled ? 1 : 0

  vpc_id               = aws_vpc.this.id
  iam_role_arn         = aws_iam_role.flow_logs[0].arn
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.flow_logs[0].arn
  traffic_type         = "ALL"

  tags = merge(local.common_tags, {
    Name = "${local.name}-networking-flow-log"
  })
}
