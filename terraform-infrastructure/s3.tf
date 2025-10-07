module "project_name_cloudfront_logs_s3" {
  source      = "./modules/s3"
  bucket_name = local.cloudfront_bucket_name

  depends_on = [module.project_name_cloudfront_logs_s3_kms]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_name_cloudfront_logs_s3_encryption" {
  bucket = module.project_name_cloudfront_logs_s3.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = module.project_name_cloudfront_logs_s3.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

module "project_name_alb_logs_s3" {
  source      = "./modules/s3"
  bucket_name = local.alb_bucket_name

  depends_on = [module.project_name_alb_logs_s3_kms]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_name_alb_logs_s3_encryption" {
  bucket = module.project_name_alb_logs_s3.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = module.project_name_alb_logs_s3.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}
