output "stage_id" {
  description = "The ID of the managed stage."
  value = aws_apigatewayv2_stage.stage.id
}

output "stage_arn" {
  description = "The ARN of the managed stage."
  value = aws_apigatewayv2_stage.stage.arn
}

output "api_mapping_id" {
  description = "The ID of the API mapping of the managed stage. This is an empty string when the domain name is not included."
  value = try(aws_apigatewayv2_api_mapping.api_mapping[0].id, "")
}

output "domain_name_id" {
  description = "The ID of the domain name of the managed stage. This is an empty string when the domain name is not included."
  value = try(aws_apigatewayv2_domain_name.domain_name[0].id, "")
}

output "domain_name_arn" {
  description = "The ARN of the domain name of the managed stage. This is an empty string when the domain name is not included."
  value = try(aws_apigatewayv2_domain_name.domain_name[0].arn, "")
}

output "domain_name_configuration" {
  description = "The domain name configuration of the domain name of the managed stage. This is an empty string when the domain name is not included."
  value = try(aws_apigatewayv2_domain_name.domain_name[0].domain_name_configuration[0], {})
}

output "access_logging_log_group_arn" {
  value = aws_cloudwatch_log_group.access_logs.arn
}
output "access_logging_log_group_name" {
  value = aws_cloudwatch_log_group.access_logs.name
}
