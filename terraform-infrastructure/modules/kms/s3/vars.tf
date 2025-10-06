variable "bucket_name" {
  description = "The name of the S3 bucket to be encrypted"
  type        = string
}

variable "bucket_key_alias" {
  description = "The alias for the KMS key"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID that will own the KMS key and has full access to it"
  type        = string
}
