module "project_name_frontend_cloudwatch_logs_kms" {
  source = "./modules/kms"

  region         = var.region
  log_group_name = local.cw_log_group_frontend_name
  account_id     = data.aws_caller_identity.current.account_id
}

module "project_name_backend_cloudwatch_logs_kms" {
  source = "./modules/kms"

  region         = var.region
  log_group_name = local.cw_log_group_backend_name
  account_id     = data.aws_caller_identity.current.account_id
}
