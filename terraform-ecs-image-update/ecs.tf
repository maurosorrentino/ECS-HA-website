module "update_frontend" {
  source = "./modules"
  task_definition_name = var.task_definition_frontend_name
  service_name = var.service_frontend_name
  cluster_name = var.cluster_name
  image_uri = var.frontend_image_uri
}

module "update_backend" {
  source = "./modules"
  task_definition_name = var.task_definition_backend_name
  service_name = var.service_backend_name
  cluster_name = var.cluster_name
  image_uri = var.backend_image_uri
}
