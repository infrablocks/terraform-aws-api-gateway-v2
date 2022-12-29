output "api_gateway_id" {
  description = "The ID of the managed API Gateway API."
  value       = aws_apigatewayv2_api.api_gateway.id
}

output "api_gateway_arn" {
  description = "The ARN of the managed API Gateway API."
  value       = aws_apigatewayv2_api.api_gateway.arn
}

output "api_gateway_name" {
  description = "The name of the managed API Gateway API."
  value       = aws_apigatewayv2_api.api_gateway.name
}

output "default_stage_id" {
  description = "The ID of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included."
  value       = try(module.default_stage[0].stage_id, "")
}

output "default_stage_arn" {
  description = "The ARN of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included."
  value       = try(module.default_stage[0].stage_arn, "")
}

output "default_stage_api_mapping_id" {
  description = "The ID of the API mapping of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included."
  value       = try(module.default_stage[0].api_mapping_id, "")
}

output "default_stage_domain_name_id" {
  description = "The ID of the domain name of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included or the default stage domain name is not included."
  value       = try(module.default_stage[0].domain_name_id, "")
}

output "default_stage_domain_name_arn" {
  description = "The ARN of the domain name of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included or the default stage domain name is not included."
  value       = try(module.default_stage[0].domain_name_arn, "")
}

output "default_stage_domain_name_configuration" {
  description = "The domain name configuration of the domain name of the default stage of the managed API Gateway API. This is an empty string when the default stage is not included or the default stage domain name is not included."
  value       = try(module.default_stage[0].domain_name_configuration, {})
}
