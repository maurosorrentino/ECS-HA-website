variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the Auto Scaling Group will launch instances"
  type        = list(string)
}

variable "template_id" {
  description = "The ID of the launch template to use for the Auto Scaling Group"
  type        = string
}
