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
    id     = "TransitionToDeepArchive"
    status = "Enabled"

    filter {} # without it gives a warning that in future it will be an error

    transition {
      days          = 30
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.project_name_s3.bucket
}

output "bucket_domain_name" {
  value = aws_s3_bucket.project_name_s3.bucket_domain_name
}
