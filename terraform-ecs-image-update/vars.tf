variable "frontend_image_uri" {
  type = string
}

variable "task_definition_frontend_name" {
  type = string
}

variable "service_frontend_name" {
  type = string
}

variable "backend_image_uri" {
  type = string
}

variable "task_definition_backend_name" {
  type = string
}
variable "service_backend_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

