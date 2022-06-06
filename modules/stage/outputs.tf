output "stage_id" {
  value = aws_apigatewayv2_stage.stage.id
}

output "stage_arn" {
  value = aws_apigatewayv2_stage.stage.arn
}

output "api_mapping_id" {
  value = try(aws_apigatewayv2_api_mapping.api_mapping[0].id, "")
}

output "domain_name_id" {
  value = try(aws_apigatewayv2_domain_name.domain_name[0].id, "")
}

output "domain_name_arn" {
  value = try(aws_apigatewayv2_domain_name.domain_name[0].arn, "")
}

output "domain_name_configuration" {
  value = try(aws_apigatewayv2_domain_name.domain_name[0].domain_name_configuration[0], {})
}

output "access_logging_log_group_arn" {
  value = aws_cloudwatch_log_group.access_logs.arn
}
output "access_logging_log_group_name" {
  value = aws_cloudwatch_log_group.access_logs.name
}
