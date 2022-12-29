output "vpc_link_id" {
  description = "The ID of the managed VPC link."
  value = aws_apigatewayv2_vpc_link.vpc_link.id
}

output "vpc_link_default_security_group_id" {
  description = "The ID of the default security group for the managed VPC link. This is an empty string when the default security group is not included."
  value = try(aws_security_group.vpc_link[0].id, "")
}
