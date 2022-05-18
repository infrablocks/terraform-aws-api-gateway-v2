data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "api_gateway" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  protocol_type = var.protocol_type

  default_stage_domain_name                 = var.default_stage_domain_name
  default_stage_domain_name_certificate_arn = var.default_stage_domain_name_certificate_arn

  include_default_stage             = var.include_default_stage
  include_default_stage_domain_name = var.include_default_stage_domain_name
  enable_default_stage_auto_deploy  = var.enable_default_stage_auto_deploy
  enable_execute_api_endpoint       = var.enable_execute_api_endpoint
}
