resource "aws_kms_key" "project_name_s3_bucket_key" {
  description         = "KMS key for S3 ${var.bucket_name}"
  enable_key_rotation = true # automatic rotation every year

  policy = templatefile("${path.root}/modules/kms/kms_policy.json", {
    account_id = var.account_id
  })
}

resource "aws_kms_alias" "project_name_s3_bucket_key_alias" {
  name          = "alias/${var.bucket_key_alias}"
  target_key_id = aws_kms_key.project_name_s3_bucket_key.id
}

output "kms_arn" {
  value = aws_kms_key.project_name_s3_bucket_key.arn
}
