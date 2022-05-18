resource "aws_apigatewayv2_domain_name" "default" {
  count = local.include_default_stage == true && local.include_default_stage_domain_name == true ? 1 : 0

  domain_name = var.default_stage_domain_name

  domain_name_configuration {
    certificate_arn = var.default_stage_domain_name_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "default" {
  count = local.include_default_stage == true && local.include_default_stage_domain_name == true ? 1 : 0

  api_id      = aws_apigatewayv2_api.api_gateway.id
  domain_name = try(aws_apigatewayv2_domain_name.default[0].id, null)
  stage       = try(aws_apigatewayv2_stage.default[0].id, null)
}