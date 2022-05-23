locals {
  # default for cases when `null` value provided, meaning "use default"
  protocol_type                     = var.protocol_type == null ? "HTTP" : var.protocol_type
  include_default_tags              = var.include_default_tags == null ? true : var.include_default_tags
  include_default_stage             = var.include_default_stage == null ? true : var.include_default_stage
  include_default_stage_domain_name = var.include_default_stage_domain_name == null ? true : var.include_default_stage_domain_name
  enable_default_stage_auto_deploy  = var.enable_default_stage_auto_deploy == null ? true : var.enable_default_stage_auto_deploy
  enable_execute_api_endpoint       = var.enable_execute_api_endpoint == null ? true : var.enable_execute_api_endpoint

  default_tags = local.include_default_tags == true ? {
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  } : {}
  tags = merge(local.default_tags, var.tags)
}
