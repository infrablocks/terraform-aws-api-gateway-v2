output "api_gateway_id" {
  value = aws_apigatewayv2_api.api_gateway.id
}

output "api_gateway_arn" {
  value = aws_apigatewayv2_api.api_gateway.arn
}

output "api_gateway_name" {
  value = aws_apigatewayv2_api.api_gateway.name
}

output "api_gateway_default_stage_id" {
  value = try(module.default_stage[0].stage_id, "")
}

output "api_gateway_default_stage_arn" {
  value = try(module.default_stage[0].stage_arn, "")
}

output "api_gateway_default_stage_api_mapping_id" {
  value = try(module.default_stage[0].api_mapping_id, "")
}

output "api_gateway_default_stage_domain_name_id" {
  value = try(module.default_stage[0].domain_name_id, "")
}

output "api_gateway_default_stage_domain_name_arn" {
  value = try(module.default_stage[0].domain_name_arn, "")
}

output "api_gateway_default_stage_domain_name_configuration" {
  value = try(module.default_stage[0].domain_name_configuration, {})
}
