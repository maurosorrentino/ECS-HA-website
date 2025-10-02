resource "aws_s3_bucket" "project_name_s3" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "project_name_s3_versioning" {
  bucket = aws_s3_bucket.project_name_s3.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "project_name_s3_lifecycle" {
  bucket = aws_s3_bucket.project_name_s3.id

  rule {
    id     = "TransitionToGlacier"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}

resource "aws_kms_key" "project_name_s3_kms" {
  description             = "KMS key for S3 log bucket encryption"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_name_s3_encryption" {
  bucket = aws_s3_bucket.project_name_s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.project_name_s3_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
