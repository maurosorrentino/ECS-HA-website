resource "aws_db_subnet_group" "project_name_rds_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("rds", name))]

  depends_on = [aws_subnet.project_name_private_subnets]
}

resource "random_password" "rds_instance_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}<>?:" # rds has some special characters that are not allowed in password
}

resource "aws_db_instance" "project_name_rds_instance" {
  identifier                          = "${var.project_name}-rds-instance"
  engine                              = "postgres"
  engine_version                      = "17.4"
  instance_class                      = "db.t3.micro" # free tier
  allocated_storage                   = 20
  storage_type                        = "gp2"
  username                            = local.rds_username
  iam_database_authentication_enabled = true
  # a password is needed anyway even if you allow with IAM auth
  password                = random_password.rds_instance_password.result
  db_subnet_group_name    = aws_db_subnet_group.project_name_rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.project_name_rds_sg.id]
  multi_az                = true
  publicly_accessible     = false
  backup_retention_period = 7 # days
  backup_window           = "03:00-04:00"
  skip_final_snapshot     = true # change to false to make it hard to destroy the infra
}
