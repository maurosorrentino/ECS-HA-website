module "project_name_frontend_ecr_repo" {
  source        = "./modules/ecr"
  ecr_repo_name = "project_name_frontend_ecr_repo"
}

module "name_project_backend_ecr_repo" {
  source        = "./modules/ecr"
  ecr_repo_name = "project_name_backend_ecr_repo"
}
