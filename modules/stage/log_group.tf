resource "aws_cloudwatch_log_group" "access_logs" {
  name = "/${var.component}/${var.deployment_identifier}/api-gateway/${local.sanitised_name}"
}
