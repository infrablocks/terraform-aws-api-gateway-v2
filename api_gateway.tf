resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "api-gateway-${var.component}-${var.deployment_identifier}"
  description   = "API gateway for component: \"${var.component}\" and deployment identifier: \"${var.deployment_identifier}\"."
  protocol_type = local.protocol_type

  disable_execute_api_endpoint = !local.enable_execute_api_endpoint

  tags = {
    Component : var.component
    DeploymentIdentifier : var.deployment_identifier
  }
}
