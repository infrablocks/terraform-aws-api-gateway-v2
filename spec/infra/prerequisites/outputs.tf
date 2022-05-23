output "certificate_arn" {
  value = module.certificate.certificate_arn
}
output "vpc_id" {
  value = module.base_networking.vpc_id
}
output "private_subnet_ids" {
  value = module.base_networking.private_subnet_ids
}
