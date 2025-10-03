# PLEASE NOTE: the following wasn't tested properly as this is a personal project and the missing piece is register a domain name
# You can uncomment and use it if you have a domain name registered in Route53, without a domain name terraform will hang 
# for an hour at "aws_acm_certificate_validation.project_name_cdn_cert_validation: Still creating..." 
# and then the token will expire making the pipeline fail. the project will continue with user talking directly to cdn
# and I will use cdn domain name (dxxxxxx.cloudfront.net) instead of a friendly name (app.project_name.com)

# resource "aws_route53_zone" "project_name_zone" {
#   name = "${var.project_name}.com"
# }

# resource "aws_route53_record" "project_name_cdn_cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.project_name_cdn_cert.domain_validation_options : dvo.domain_name => dvo
#   }

#   name    = each.value.resource_record_name
#   type    = each.value.resource_record_type
#   zone_id = aws_route53_zone.project_name_zone.zone_id
#   records = [each.value.resource_record_value]
#   ttl     = 300

#   depends_on = [aws_acm_certificate.project_name_cdn_cert]
# }

# resource "aws_route53_record" "project_name_cdn_alias" {
#   zone_id = aws_route53_zone.project_name_zone.zone_id
#   name    = "app.${var.project_name}.com"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.project_name_cdn.domain_name
#     zone_id                = aws_cloudfront_distribution.project_name_cdn.hosted_zone_id
#     evaluate_target_health = false # ALB will do the health check
#   }
# }
