module "default_stage" {
  count = local.include_default_stage == true ? 1 : 0

  source = "./modules/stage"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  name   = "$default"
  api_id = aws_apigatewayv2_api.api_gateway.id

  domain_name                 = var.default_stage_domain_name
  domain_name_certificate_arn = var.default_stage_domain_name_certificate_arn

  tags = var.tags

  include_default_tags = local.include_default_tags
  include_domain_name  = local.include_default_stage_domain_name
  enable_auto_deploy   = local.enable_default_stage_auto_deploy
}
