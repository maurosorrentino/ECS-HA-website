data "aws_secretsmanager_secret_version" "project_name_rds_instance_creds" {
  secret_id = "${var.project_name}/rds_instance_creds"
}
