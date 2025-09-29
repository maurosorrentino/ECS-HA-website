resource "aws_route53_zone" "project_name_zone" {
  name = "${var.project_name}.com"
}

resource "aws_route53_record" "project_name_cdn_cert_validation" {
  name    = aws_acm_certificate.project_name_cdn_cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.project_name_cdn_cert.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.project_name_zone.zone_id
  records = [aws_acm_certificate.project_name_cdn_cert.domain_validation_options[0].resource_record_value]
  ttl     = 300

  depends_on = [aws_acm_certificate.project_name_cdn_cert]
}

resource "aws_route53_record" "project_name_cdn_alias" {
  zone_id = aws_route53_zone.project_name_zone.zone_id
  name    = "app.${var.project_name}.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.project_name_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.project_name_cdn.hosted_zone_id
    evaluate_target_health = false # ALB will do the health check
  }
}
