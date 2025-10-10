resource "aws_cloudfront_distribution" "project_name_cdn" {
  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = module.project_name_frontend_alb.alb_dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id = "alb-origin"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    # Redirect HTTP clients to HTTPS at the edge
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0     # min_ttl = 0 means CloudFront can revalidate with the origin on every request if needed.
    default_ttl = 3600  # 1 hour, minimum time CloudFront keeps an object in cache before it checks the origin for an updated version.
    max_ttl     = 86400 # 24 hours, maximum time CloudFront keeps an object in cache before it checks the origin for an updated version.

    # Compress text-based responses (gzip/brotli where supported)
    compress = true
  }

  # can cache based on specific API as well
  # ordered_cache_behavior {
  #   path_pattern     = "/api/*"
  #   target_origin_id = "alb-origin"
  #   allowed_methods  = ["GET","HEAD","OPTIONS","POST","PUT","PATCH","DELETE"]
  #   cached_methods   = ["GET","HEAD"]
  #   viewer_protocol_policy = "https-only"
  #   forwarded_values { ... }
  #   min_ttl = 0
  #   default_ttl = 0
  #   max_ttl = 86400
  # }

  logging_config {
    bucket = module.project_name_cloudfront_logs_s3.bucket_domain_name
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # please see acm.tf and route53.tf for the certificate creation and validation
  # uncomment the following viewer_certificate block and comment the above one if you have a domain name
  # viewer_certificate {
  #   cloudfront_default_certificate = false
  #   acm_certificate_arn            = aws_acm_certificate.project_name_cdn_cert.arn
  #   ssl_support_method             = "sni-only"
  #   minimum_protocol_version       = "TLSv1.2_2021"
  # }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${var.project_name}-cloudfront"
  }

  # if you have a domain add aws_acm_certificate.project_name_cdn_cert in depends_on
  depends_on = [module.project_name_frontend_alb, module.project_name_cloudfront_logs_s3]
}
