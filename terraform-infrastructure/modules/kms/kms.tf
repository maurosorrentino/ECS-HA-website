resource "aws_kms_key" "project_name_s3_bucket_key" {
  description         = "KMS key for S3 ${var.bucket_name}"
  enable_key_rotation = true # automatic rotation every year
}

resource "aws_kms_alias" "project_name_s3_bucket_key_alias" {
  name          = "alias/${var.bucket_key_alias}"
  target_key_id = aws_kms_key.project_name_s3_bucket_key.id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = var.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.project_name_s3_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
