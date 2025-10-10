module "project_name_frontend_cloudwatch_logs_kms" {
  source = "./modules/kms"

  account_id = data.aws_caller_identity.current.account_id
}

module "project_name_backend_cloudwatch_logs_kms" {
  source = "./modules/kms"

  account_id = data.aws_caller_identity.current.account_id
}
