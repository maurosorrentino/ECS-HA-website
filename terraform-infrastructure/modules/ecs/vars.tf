variable "task_name" {
  description = "The name of the ECS task"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "The ID of the ECS cluster"
  type        = string
}

variable "task_arn" {
  description = "The ARN of the ECS task definition"
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
