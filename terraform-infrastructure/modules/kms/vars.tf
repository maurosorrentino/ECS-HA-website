variable "bucket_name" {
  description = "The name of the S3 bucket to be encrypted"
  type        = string
}

variable "bucket_key_alias" {
  description = "The alias for the KMS key"
  type        = string
}
