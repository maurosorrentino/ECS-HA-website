resource "aws_kms_key" "project_name_cloudwatch_logs" {
  description             = "CloudWatch Logs encryption key"
  enable_key_rotation     = true

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowRootAndAdminAccess",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            # need for terraform destroy, do not use in prod
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root", 
            # allow users with a specific role to decrypt logs
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/devGitHubActionsProjectNameRole" 
          ]
        },
        # in prod limit the actions to what is strictly necessary
        # I want everything for destroying the stack easily
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "AllowCloudWatchLogsUse",
        "Effect": "Allow",
        "Principal": {
          "Service": "logs.eu-west-2.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
    ]
  })
}

output "kms_arn" {
  value = aws_kms_key.project_name_cloudwatch_logs.arn
}
