module "api_gateway" {
  source = "../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  protocol_type = "HTTP"

  default_stage_domain_name                 = var.domain_name
  default_stage_domain_name_certificate_arn = module.certificate.certificate_arn

  hosted_zone_id = var.public_zone_id

  tags = {
    Role: "webhooks"
  }

  providers = {
    aws = aws
    aws.dns = aws
  }

  depends_on = [
    module.certificate
  ]
}
