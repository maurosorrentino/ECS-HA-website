resource "aws_s3_bucket_policy" "project_name_logs_policy" {
  bucket = aws_s3_bucket.project_name_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowALBToWriteLogs"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.project_name_s3.arn}/*"
        Condition = {
          StringEquals = var.string_equals_condition
        }
      }
    ]
  })
}
