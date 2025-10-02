# TODO module
resource "aws_s3_bucket" "project_name_cloudfront_logs_s3" {
  bucket = "${var.project_name}-cloudfront-logs-bucket"
}

resource "aws_s3_bucket" "project_name_alb_logs_s3" {
  bucket = "${var.project_name}-alb-logs-bucket"
}

resource "aws_s3_bucket_versioning" "project_name_cloudfront_logs_versioning" {
  bucket = aws_s3_bucket.project_name_cloudfront_logs_s3.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "project_name_alb_logs_versioning" {
  bucket = aws_s3_bucket.project_name_alb_logs_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "project_name_cloudfront_logs_lifecycle" {
  bucket = aws_s3_bucket.project_name_cloudfront_logs_s3.id

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

resource "aws_s3_bucket_lifecycle_configuration" "project_name_alb_logs_lifecycle" {
  bucket = aws_s3_bucket.project_name_alb_logs_s3.id

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

resource "aws_kms_key" "project_name_s3_logs_kms" {
  description             = "KMS key for S3 log bucket encryption"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_name_cloudfront_logs_encryption" {
  bucket = aws_s3_bucket.project_name_cloudfront_logs_s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.project_name_s3_logs_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_name_alb_logs_encryption" {
  bucket = aws_s3_bucket.project_name_alb_logs_s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.project_name_s3_logs_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "project_name_cloudfront_logs_public_access" {
  bucket                  = aws_s3_bucket.project_name_cloudfront_logs_s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "project_name_alb_logs_public_access" {
  bucket                  = aws_s3_bucket.project_name_alb_logs_s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
