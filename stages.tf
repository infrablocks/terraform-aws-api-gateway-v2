resource "aws_apigatewayv2_stage" "default" {
  count       = local.include_default_stage == true ? 1 : 0
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "$default"
  description = "Default route for component: ${var.component} and deployment identifier: ${var.deployment_identifier}."
  auto_deploy = local.enable_auto_deploy_for_default_stage

  tags = {
    Component : var.component
    DeploymentIdentifier : var.deployment_identifier
  }
}
