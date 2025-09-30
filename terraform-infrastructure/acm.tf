resource "aws_acm_certificate" "project_name_cdn_cert" {
  domain_name       = "app.${var.project_name}.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "project_name_cdn_cert_validation" {
  certificate_arn         = aws_acm_certificate.project_name_cdn_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.project_name_cdn_cert_validation : record.fqdn]

  depends_on = [aws_route53_record.project_name_cdn_cert_validation]
}
