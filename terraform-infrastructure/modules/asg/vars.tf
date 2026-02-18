variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the Auto Scaling Group will launch instances"
  type        = list(string)
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

# this is an example of variable that can be used based on the environment
# the value it's passed from the pipeline to use the same code for each environemnt
variable "environment" {
  type = string
}
