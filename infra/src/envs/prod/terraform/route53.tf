data "aws_route53_zone" "api" {
  name         = var.domain_names.api
  private_zone = false
}

resource "aws_route53_record" "api_validation" {
  for_each = { for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => dvo }

  zone_id = data.aws_route53_zone.api.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}