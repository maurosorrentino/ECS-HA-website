variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "The ID of the ECS cluster"
  type        = string
}

variable "subnets_ids" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}

variable "security_groups_ids" {
  description = "List of security group IDs for the ECS service"
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

variable "launch_template_security_groups_ids" {
  description = "List of security group IDs for the launch template"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}
