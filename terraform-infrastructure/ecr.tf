module "project_name_frontend_ecr_repo" {
  source        = "./modules/ecr"
  ecr_repo_name = "${var.project_name}-frontend-ecr-repo"
}

module "project_name_backend_ecr_repo" {
  source        = "./modules/ecr"
  ecr_repo_name = "${var.project_name}-backend-ecr-repo"
}
