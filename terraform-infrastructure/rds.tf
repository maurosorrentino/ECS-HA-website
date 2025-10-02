resource "aws_db_subnet_group" "project_name_rds_subnet_group" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("rds", name))]

  depends_on = [aws_subnet.project_name_private_subnets]
}

resource "aws_db_instance" "project_name_rds_instance" {
  identifier             = "${var.project_name}-rds-instance"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "admin"
  password               = "SuperSecret123!" # TODO secret manager
  db_subnet_group_name   = aws_db_subnet_group.project_name_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.project_name_rds_sg.id]
  multi_az               = true
  publicly_accessible    = false
  backup_retention_period = 7 # days
  backup_window          = "03:00-04:00"
  skip_final_snapshot    = false
}
