locals {
  # default for cases when `null` value provided, meaning "use default"
  protocol_type                        = var.protocol_type == null ? "HTTP" : var.protocol_type
  include_default_stage                = var.include_default_stage == null ? true : var.include_default_stage
  enable_execute_api_endpoint          = var.enable_execute_api_endpoint == null ? true : var.enable_execute_api_endpoint
  enable_auto_deploy_for_default_stage = var.enable_auto_deploy_for_default_stage == null ? true : var.enable_auto_deploy_for_default_stage
}
