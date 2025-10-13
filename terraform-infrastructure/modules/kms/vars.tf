variable "account_id" {
  description = "The AWS account ID that will own the KMS key and has full access to it"
  type        = string
}

variable "region" {
  description = "region cloudwatch log groups"
  type        = string
}

variable "log_group_name" {
  description = "log group name for kms policy"
  type        = string
}
