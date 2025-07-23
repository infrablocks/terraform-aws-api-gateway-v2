resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "api-gateway-${var.component}-${var.deployment_identifier}"
  description   = "API gateway for component: \"${var.component}\" and deployment identifier: \"${var.deployment_identifier}\"."
  protocol_type = local.protocol_type

  disable_execute_api_endpoint = !local.enable_execute_api_endpoint

  tags = local.tags

  dynamic "cors_configuration" {
    for_each = var.cors_enabled ? [1] : []
    content {
      allow_origins     = var.cors_allow_origins
      allow_methods     = var.cors_allow_methods
      allow_headers     = var.cors_allow_headers
      max_age           = var.cors_max_age
      allow_credentials = var.cors_allow_credentials
      expose_headers    = var.cors_expose_headers
    }
  }
}

