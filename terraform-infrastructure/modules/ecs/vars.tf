variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "The ID of the ECS cluster"
  type        = string
}

variable "launch_template_security_groups_ids" {
  description = "List of security group IDs for the launch template"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "The ARN of the ALB target group"
  type        = string
}

variable "launch_template_name_prefix" {
  description = "The prefix for the launch template name"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile for ECS instances"
  type        = string
}

variable "task_security_group_ids" {
  description = "List of security group IDs for the tasks"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnets for tasks ENIs"
  type        = list(string)
}
