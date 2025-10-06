resource "aws_cloudwatch_log_group" "project_name_frontend_service_log_group" {
  name              = "ecs/${var.project_name}-frontend-service-log-group"
  retention_in_days = 365
}

resource "aws_cloudwatch_log_group" "project_name_backend_service_log_group" {
  name              = "ecs/${var.project_name}-backend-service-log-group"
  retention_in_days = 365
}

# TODO kms
