data "aws_availability_zones" "zones" {}

module "certificate" {
  source  = "infrablocks/acm-certificate/aws"
  version = "1.1.0"

  domain_name = var.domain_name
  domain_zone_id = var.public_zone_id

  subject_alternative_names = []
  subject_alternative_name_zone_id = var.public_zone_id

  providers = {
    aws.certificate = aws
    aws.domain_validation = aws
    aws.san_validation = aws
  }
}

module "base_networking" {
  source  = "infrablocks/base-networking/aws"
  version = "4.0.0"

  region = var.region
  availability_zones = data.aws_availability_zones.zones.names

  component = var.component
  deployment_identifier = var.deployment_identifier

  vpc_cidr = "10.0.0.0/16"

  include_nat_gateways = "no"
  include_route53_zone_association = "no"
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "provided-api-gateway-${var.component}-${var.deployment_identifier}"
  description   = "Provided API gateway for component: \"${var.component}\" and deployment identifier: \"${var.deployment_identifier}\"."
  protocol_type = "HTTP"
}

resource "aws_security_group" "vpc_link" {
  name        = "provided-vpc-link-sg-${var.component}-${var.deployment_identifier}"
  description = "Provided VPC link security group for: ${var.component}, deployment: ${var.deployment_identifier}"
  vpc_id      = module.base_networking.vpc_id
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "provided-vpc-link-${var.component}-${var.deployment_identifier}"
  security_group_ids = [aws_security_group.vpc_link.id]
  subnet_ids         = module.base_networking.private_subnet_ids
}
