module "project_name_cloudfront_logs_s3" {
  source      = "./modules/s3"
  bucket_name = local.cloudfront_bucket_name
}

module "project_name_alb_logs_s3" {
  source      = "./modules/s3"
  bucket_name = local.alb_bucket_name
}
