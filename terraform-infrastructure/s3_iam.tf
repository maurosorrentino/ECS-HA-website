data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "project_name_cloudfront_logs_policy" {
  bucket = aws_s3_bucket.project_name_cloudfront_logs_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowCloudFrontToWriteLogs"
        Effect   = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.project_name_cloudfront_logs_s3.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket.project_name_alb_logs_s3]
}

resource "aws_s3_bucket_policy" "project_name_alb_logs_policy" {
  bucket = aws_s3_bucket.project_name_alb_logs_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowALBToWriteLogs"
        Effect   = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.project_name_alb_logs_s3.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket.project_name_alb_logs_s3]
}
