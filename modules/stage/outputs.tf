output "stage_id" {
  value = try(aws_apigatewayv2_stage.stage.id, null)
}

output "stage_arn" {
  value = try(aws_apigatewayv2_stage.stage.arn, null)
}

output "stage_api_mapping_id" {
  value = try(aws_apigatewayv2_api_mapping.api_mapping[0].id, null)
}
