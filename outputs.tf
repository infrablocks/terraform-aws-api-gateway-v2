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
  value = try(aws_apigatewayv2_stage.default[0].id, null)
}

output "api_gateway_default_stage_arn" {
  value = try(aws_apigatewayv2_stage.default[0].arn, null)
}

output "api_gateway_default_stage_api_mapping_id" {
  value = try(aws_apigatewayv2_api_mapping.default[0].id, null)
}
