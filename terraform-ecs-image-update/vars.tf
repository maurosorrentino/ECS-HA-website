variable "frontend_image_uri" {
  type    = string
  default = "FRONTEND_IMAGE"
}

# TODO add env variable
variable "task_definition_frontend_name" {
  type = string
}

variable "service_frontend_name" {
  type    = string
  default = "frontend-service"
}

variable "backend_image_uri" {
  type    = string
  default = "BACKEND_IMAGE"
}

# TODO add env variable
variable "task_definition_backend_name" {
  type = string
}

variable "service_backend_name" {
  type    = string
  default = "backend-service"
}

variable "cluster_name" {
  type = string
}

variable "project_name" {
  type    = string
  default = "project-name"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

