

# PLEASE NOTE: the following is now working as this is a personal project and the missing piece is register a domain name
# You can uncomment and use it if you have a domain name registered in Route53, without a domain name terraform will hang 
# for an hour at "aws_acm_certificate_validation.project_name_cdn_cert_validation: Still creating..." 
# and then the token will expire making the pipeline fail. the project will continue with user talking directly to cdn
# and I will use cdn domain name (dxxxxxx.cloudfront.net) instead of a friendly name (app.project_name.com)

# resource "aws_acm_certificate" "project_name_cdn_cert" {
#   domain_name       = "app.${var.project_name}.com"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate_validation" "project_name_cdn_cert_validation" {
#   certificate_arn         = aws_acm_certificate.project_name_cdn_cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.project_name_cdn_cert_validation : record.fqdn]

#   depends_on = [aws_route53_record.project_name_cdn_cert_validation]
# }
