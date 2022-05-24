resource "aws_apigatewayv2_domain_name" "domain_name" {
  count = local.include_domain_name == true ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.domain_name_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = local.tags
}

resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  count = local.include_domain_name == true ? 1 : 0

  api_id      = var.api_id
  domain_name = try(aws_apigatewayv2_domain_name.domain_name[0].id, null)
  stage       = try(aws_apigatewayv2_stage.stage.id, null)
}
