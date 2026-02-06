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

variable "instance_profile_name" {
  type = string
}

variable "launch_template_name_prefix" {
  type = string
}

variable "launch_template_security_groups_ids" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}
