output "certificate_arn" {
  value = module.certificate.certificate_arn
}
output "vpc_id" {
  value = module.base_networking.vpc_id
}
output "private_subnet_ids" {
  value = module.base_networking.private_subnet_ids
}
output "api_id" {
  value = aws_apigatewayv2_api.api_gateway.id
}
output "vpc_link_security_group_id" {
  value = aws_security_group.vpc_link.id
}
output "log_group_arn" {
  value = aws_cloudwatch_log_group.log_group.arn
}
output "domain_name" {
  value = var.domain_name
}
output "public_zone_id" {
  value = var.public_zone_id
}
