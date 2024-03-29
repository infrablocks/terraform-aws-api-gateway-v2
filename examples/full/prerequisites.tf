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
  version = "5.0.0"

  region = var.region
  availability_zones = data.aws_availability_zones.zones.names

  component = var.component
  deployment_identifier = var.deployment_identifier

  vpc_cidr = "10.0.0.0/16"

  include_nat_gateways = "no"
  include_route53_zone_association = "no"
}