data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "stage" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../modules/stage"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  api_id = var.api_id
  name   = var.name

  domain_name                 = var.domain_name
  domain_name_certificate_arn = var.domain_name_certificate_arn

  hosted_zone_id = var.hosted_zone_id

  tags = var.tags

  include_default_tags = var.include_default_tags
  include_domain_name  = var.include_domain_name
  include_dns_record   = var.include_dns_record
  enable_auto_deploy   = var.enable_auto_deploy

  providers = {
    aws     = aws
    aws.dns = aws
  }
}
