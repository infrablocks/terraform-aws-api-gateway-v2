output "logging_role_id" {
  description = "The ID of the managed API Gateway logging role."
  value = aws_iam_role.api_gateway_logging_role.id
}

output "logging_role_arn" {
  description = "The ARN of the managed API Gateway logging role."
  value = aws_iam_role.api_gateway_logging_role.arn
}

output "logging_role_name" {
  description = "The name of the managed API Gateway logging role."
  value = aws_iam_role.api_gateway_logging_role.name
}

output "logging_role_policy_id" {
  description = "The ID of the policy attached to the API Gateway logging role."
  value = aws_iam_role_policy.api_gateway_logging_role_policy.id
}

output "logging_role_policy_name" {
  description = "The name of the policy attached to the API Gateway logging role."
  value = aws_iam_role_policy.api_gateway_logging_role_policy.name
}
