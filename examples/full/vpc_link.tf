module "vpc_link" {
  source = "../../modules/vpc_link"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id              = module.base_networking.vpc_id
  vpc_link_subnet_ids = module.base_networking.private_subnet_ids

  tags = {
    Service: "payments"
  }
}
