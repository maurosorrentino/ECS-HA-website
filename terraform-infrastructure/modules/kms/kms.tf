resource "aws_kms_key" "project_name_cloudwatch_logs" {
  description         = "CloudWatch Logs encryption key"
  enable_key_rotation = true

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowRootAndAdminAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            # need for terraform destroy, do not use in prod
            "arn:aws:iam::${var.account_id}:root",
            # allow users with a specific role to decrypt logs
            "arn:aws:iam::${var.account_id}:role/devGitHubActionsProjectNameRole"
          ]
        },
        # in prod limit the actions to what is strictly necessary
        # I want everything for destroying the stack easily
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowCloudWatchLogsUse",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.${var.region}.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*",
        "Condition" : {
          "ArnEquals" : {
            "kms:EncryptionContext:aws:logs:arn" : "arn:aws:logs:${var.region}:${var.account_id}:log-group:${var.log_group_name}"
          }
        }
      }
    ]
  })
}

output "kms_arn" {
  value = aws_kms_key.project_name_cloudwatch_logs.arn
}
