module "project_name_frontend_ecr_repo" {
  source        = "./modules/ecr"
  ecr_repo_name = var.frontend_ecr_repo_name
}

module "project_name_backend_ecr_repo" {
  source        = "./modules/ecr"
  ecr_repo_name = var.backend_ecr_repo_name
}
