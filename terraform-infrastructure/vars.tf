# default values are for running terraform locally
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "frontend_service_name" {
  type = string
}

variable "backend_service_name" {
  type = string
}

# this is an example of variable that can be used based on the environment
# the value it's passed from the pipeline to use the same code for each environemnt
variable "environment" {
  type = string
  default = "dev"
}

variable "ecs_cluster_name" {
  type = string
}
