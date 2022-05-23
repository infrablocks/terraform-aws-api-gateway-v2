locals {
  # default for cases when `null` value provided, meaning "use default"
  include_domain_name  = var.include_domain_name == null ? true : var.include_domain_name
  include_default_tags = var.include_default_tags == null ? true : var.include_default_tags
  enable_auto_deploy   = var.enable_auto_deploy == null ? true : var.enable_auto_deploy

  default_tags = local.include_default_tags == true ? {
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  } : {}
  tags = merge(local.default_tags, var.tags)
}
