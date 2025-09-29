resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name       = "mauro.com" # TODO var
  validation_method = "DNS"

  subject_alternative_names = [
    "www.mauro.com" # TODO var
  ]
}


