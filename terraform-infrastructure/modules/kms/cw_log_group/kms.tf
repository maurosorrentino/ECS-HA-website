resource "aws_kms_key" "project_name_cloudwatch_logs" {
  description             = "CloudWatch Logs encryption key"
  enable_key_rotation     = true

  policy = templatefile("${path.root}/modules/kms/kms_policy.json", {
    account_id = var.account_id
  })
}

output "kms_key_id" {
  value = aws_kms_key.project_name_cloudwatch_logs.id
}
