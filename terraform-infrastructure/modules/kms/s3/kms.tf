resource "aws_kms_key" "project_name_s3_bucket_key" {
  description         = "KMS key for S3 ${var.bucket_name}"
  enable_key_rotation = true # automatic rotation every year

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowRootAndAdminAccess",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            # need for terraform destroy, do not use in prod
            "arn:aws:iam::${var.account_id}:root", 
            # allow users with a specific role to decrypt logs
            "arn:aws:iam::${var.account_id}:role/devGitHubActionsProjectNameRole" 
          ]
        },
        # in prod limit the actions to what is strictly necessary
        # I want everything for destroying the stack easily
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "AllowS3Use",
        "Effect": "Allow",
        "Principal": {
          "Service": "s3.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      },
      {
        "Sid": "AllowALBUse",
        "Effect": "Allow",
        "Principal": {
          "Service": "elasticloadbalancing.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_kms_alias" "project_name_s3_bucket_key_alias" {
  name          = "alias/${var.bucket_key_alias}"
  target_key_id = aws_kms_key.project_name_s3_bucket_key.id
}

output "kms_arn" {
  value = aws_kms_key.project_name_s3_bucket_key.arn
}
