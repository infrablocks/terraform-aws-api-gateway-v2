output "logging_role_id" {
  value = aws_iam_role.api_gateway_logging_role.id
}

output "logging_role_arn" {
  value = aws_iam_role.api_gateway_logging_role.arn
}

output "logging_role_name" {
  value = aws_iam_role.api_gateway_logging_role.name
}

output "logging_role_policy_id" {
  value = aws_iam_role_policy.api_gateway_logging_role_policy.id
}

output "logging_role_policy_name" {
  value = aws_iam_role_policy.api_gateway_logging_role_policy.name
}
