data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "vpc_link" {
  source = "../../../../modules/vpc_link"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  vpc_id              = var.vpc_id
  vpc_link_subnet_ids = var.vpc_link_subnet_ids

  tags = var.tags

  include_default_tags                    = var.include_default_tags
  include_vpc_link_default_security_group = var.include_vpc_link_default_security_group
  include_vpc_link_default_ingress_rule   = var.include_vpc_link_default_ingress_rule
  include_vpc_link_default_egress_rule    = var.include_vpc_link_default_egress_rule
}
