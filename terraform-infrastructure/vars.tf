# default values are for running terraform locally
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "project-name"
}

# this is an example of variable that can be used based on the environment
# the value it's passed from the pipeline to use the same code for each environemnt
variable "environment" {
  type = string
  default = "dev"
}
