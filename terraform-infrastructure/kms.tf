module "project_name_cloudfront_logs_s3_kms" {
  source = "./modules/kms"

  bucket_key_alias = "${local.cloudfront_bucket_name}-kms-key"
  bucket_name      = local.cloudfront_bucket_name
  account_id       = data.aws_caller_identity.current.account_id
}

module "project_name_alb_logs_s3_kms" {
  source = "./modules/kms"

  bucket_key_alias = "${local.alb_bucket_name}-kms-key"
  bucket_name      = local.alb_bucket_name
  account_id       = data.aws_caller_identity.current.account_id
}
