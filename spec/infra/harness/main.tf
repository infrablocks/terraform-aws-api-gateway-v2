data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "api_gateway" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../"

  component = var.component
  deployment_identifier = var.deployment_identifier

  protocol_type = var.protocol_type

  include_default_stage = var.include_default_stage
  enable_execute_api_endpoint = var.enable_execute_api_endpoint
  enable_auto_deploy_for_default_stage = var.enable_auto_deploy_for_default_stage
}
