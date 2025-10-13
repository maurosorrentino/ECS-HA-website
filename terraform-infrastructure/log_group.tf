resource "aws_cloudwatch_log_group" "project_name_frontend_service_log_group" {
  name              = local.cw_log_group_frontend_name
  retention_in_days = 365
  kms_key_id        = module.project_name_frontend_cloudwatch_logs_kms.kms_arn

  depends_on = [module.project_name_frontend_cloudwatch_logs_kms]
}

resource "aws_cloudwatch_log_group" "project_name_backend_service_log_group" {
  name              = local.cw_log_group_backend_name
  retention_in_days = 365
  kms_key_id        = module.project_name_backend_cloudwatch_logs_kms.kms_arn

  depends_on = [module.project_name_backend_cloudwatch_logs_kms]
}
