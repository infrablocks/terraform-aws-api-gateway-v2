output "private_subnet_ids" {
  value = module.base_networking.private_subnet_ids
}

output "certificate_arn" {
  value = module.certificate.certificate_arn
}

output "api_gateway_id" {
  value = module.api_gateway.api_gateway_id
}

output "api_gateway_arn" {
  value = module.api_gateway.api_gateway_arn
}

output "api_gateway_name" {
  value = module.api_gateway.api_gateway_name
}

output "default_stage_id" {
  value = module.api_gateway.default_stage_id
}

output "default_stage_arn" {
  value = module.api_gateway.default_stage_arn
}

output "default_stage_api_mapping_id" {
  value = module.api_gateway.default_stage_api_mapping_id
}

output "default_stage_domain_name_id" {
  value = module.api_gateway.default_stage_domain_name_id
}

output "default_stage_domain_name_arn" {
  value = module.api_gateway.default_stage_domain_name_arn
}

output "default_stage_domain_name_configuration" {
  value = module.api_gateway.default_stage_domain_name_configuration
}

output "vpc_link_id" {
  value = module.vpc_link.vpc_link_id
}

output "vpc_link_default_security_group_id" {
  value = module.vpc_link.vpc_link_default_security_group_id
}
