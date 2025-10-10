module "project_name_cloudfront_logs_s3" {
  source      = "./modules/s3"
  bucket_name = "${var.project_name}-cloudfront-logs"
}

module "project_name_alb_logs_s3" {
  source      = "./modules/s3"
  bucket_name = "${var.project_name}-alb-logs"
}

# cloudfront still depends on ACLs instead of Bucket policies
resource "aws_s3_bucket_ownership_controls" "cloudfront_logs" {
  bucket = module.project_name_cloudfront_logs_s3.bucket_id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Allow CloudFront to write logs
resource "aws_s3_bucket_acl" "cloudfront_logs" {
  bucket = module.project_name_cloudfront_logs_s3.bucket_id
  acl    = "log-delivery-write"
}
