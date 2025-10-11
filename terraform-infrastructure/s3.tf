module "project_name_cloudfront_logs_s3" {
  source      = "./modules/s3"
  bucket_name = "${var.project_name}-cloudfront-logs"
}

module "project_name_alb_logs_s3" {
  source      = "./modules/s3"
  bucket_name = "${var.project_name}-alb-logs"
}
