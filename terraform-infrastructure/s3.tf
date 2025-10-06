module "project_name_cloudfront_logs_s3" {
  source      = "./modules/s3"
  bucket_name = local.cloudfront_bucket_name
  kms_key_arn = module.project_name_cloudfront_logs_s3_kms.kms_arn
  
  string_equals_condition = {
    "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
  }

  depends_on = [module.project_name_cloudfront_logs_s3_kms]
}

module "project_name_alb_logs_s3" {
  source      = "./modules/s3"
  bucket_name = local.alb_bucket_name
  kms_key_arn = module.project_name_alb_logs_s3_kms.kms_arn

  string_equals_condition = {
    "s3:x-amz-acl" = "bucket-owner-full-control"
  }

  depends_on = [module.project_name_alb_logs_s3_kms]
}
