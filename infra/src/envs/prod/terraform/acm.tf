resource "aws_acm_certificate" "api" {
  domain_name       = data.aws_route53_zone.api.name
  validation_method = "DNS"
}