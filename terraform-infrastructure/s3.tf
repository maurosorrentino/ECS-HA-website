resource "aws_s3_bucket" "cloudfront_logs_s3" {
  bucket = "${var.project_name}-cloudfront-logs-bucket"
}

# TODO kms for encryption
# TODO bucket policy to allow cloudfront to write logs
# TODO versioning
# TODO lifecycle rules to transition to glacier
# TODO public access block (I think it's on by default)

