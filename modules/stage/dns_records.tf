resource "aws_route53_record" "record" {
  provider = "aws.dns"

  count = var.include_domain_name == true && var.include_dns_record == true ? 1 : 0

  zone_id = var.hosted_zone_id
  name = var.domain_name
  type = "A"

  alias {
    name = try(aws_apigatewayv2_domain_name.domain_name[0].domain_name_configuration[0].target_domain_name, null)
    zone_id = try(aws_apigatewayv2_domain_name.domain_name[0].domain_name_configuration[0].hosted_zone_id, null)
    evaluate_target_health = false
  }
}
