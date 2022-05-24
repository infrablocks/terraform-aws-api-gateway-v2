locals {
  # default for cases when `null` value provided, meaning "use default"
  hosted_zone_id       = var.hosted_zone_id == null ? "" : var.hosted_zone_id
  include_default_tags = var.include_default_tags == null ? true : var.include_default_tags
  include_domain_name  = var.include_domain_name == null ? true : var.include_domain_name
  include_dns_record   = var.include_dns_record == null ? true : var.include_dns_record
  enable_auto_deploy   = var.enable_auto_deploy == null ? true : var.enable_auto_deploy

  default_tags = local.include_default_tags == true ? {
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  } : {}
  tags = merge(local.default_tags, var.tags)
}
