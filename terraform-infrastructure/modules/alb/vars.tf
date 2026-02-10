variable "alb_target_group_name" {
  description = "The name of the ALB target group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "alb_subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_security_groups" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "s3_prefix" {
  description = "Prefix for the S3 bucket to store ALB access logs"
  type        = string
}

variable "bucket_id" {
  description = "The ID of the S3 bucket to store ALB access logs"
  type        = string
}

variable "listener_port" {
  type = string
}
