module "update_frontend" {
  source       = "./modules"
  service_name = var.service_frontend_name
  cluster_name = var.cluster_name
  image_uri    = var.frontend_image_uri
}

module "update_backend" {
  source       = "./modules"
  service_name = var.service_backend_name
  cluster_name = var.cluster_name
  image_uri    = var.backend_image_uri
}
