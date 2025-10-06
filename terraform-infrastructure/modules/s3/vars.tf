variable "bucket_name" {
  description = "The name of the S3 bucket to be encrypted"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to be used for S3 bucket encryption"
  type        = string
}
