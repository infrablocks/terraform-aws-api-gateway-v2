resource "aws_apigatewayv2_stage" "stage" {
  api_id      = var.api_id
  name        = var.name
  description = "Stage: ${var.name} for component: ${var.component} and deployment identifier: ${var.deployment_identifier}."
  auto_deploy = local.enable_auto_deploy

  tags = local.tags

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access_logs.arn
    format          = var.access_logging_log_format
  }
}
