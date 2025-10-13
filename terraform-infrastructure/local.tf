locals {
  rds_username               = data.aws_secretsmanager_secret_version.project_name_rds_instance_username.secret_string
  s3_frontend_alb_prefix     = "frontend-alb-logs"
  s3_backend_alb_prefix      = "backend-alb-logs"
  cw_log_group_frontend_name = "ecs/${var.project_name}-frontend-service-log-group"
  cw_log_group_backend_name  = "ecs/${var.project_name}-backend-service-log-group"

  # 256 IPs addresses per subnet
  private_subnets = [
    {
      name = "${var.project_name}-backend-private-subnet-a"
      cidr = "10.0.1.0/24"
      az   = "eu-west-2a"
    },
    {
      name = "${var.project_name}-backend-private-subnet-b"
      cidr = "10.0.3.0/24"
      az   = "eu-west-2b"
    },
    {
      name = "${var.project_name}-backend-private-subnet-c"
      cidr = "10.0.5.0/24"
      az   = "eu-west-2c"
    },
    {
      name = "${var.project_name}-frontend-private-subnet-a"
      cidr = "10.0.2.0/24"
      az   = "eu-west-2a"
    },
    {
      name = "${var.project_name}-frontend-private-subnet-b"
      cidr = "10.0.4.0/24"
      az   = "eu-west-2b"
    },
    {
      name = "${var.project_name}-frontend-private-subnet-c"
      cidr = "10.0.6.0/24"
      az   = "eu-west-2c"
    },
    {
      name = "${var.project_name}-rds-private-subnet-a"
      cidr = "10.0.7.0/24"
      az   = "eu-west-2a"
    },
    {
      name = "${var.project_name}-rds-private-subnet-b"
      cidr = "10.0.8.0/24"
      az   = "eu-west-2b"
    },
    {
      name = "${var.project_name}-rds-private-subnet-c"
      cidr = "10.0.9.0/24"
      az   = "eu-west-2c"
    },
    {
      name = "${var.project_name}-alb-private-subnet-a"
      cidr = "10.0.10.0/24"
      az   = "eu-west-2a"
    },
    {
      name = "${var.project_name}-alb-private-subnet-b"
      cidr = "10.0.11.0/24"
      az   = "eu-west-2b"
    },
    {
      name = "${var.project_name}-alb-private-subnet-c"
      cidr = "10.0.12.0/24"
      az   = "eu-west-2c"
    }
  ]

  # 16 IPs addresses per subnet
  public_subnets = [
    {
      name = "${var.project_name}-public-subnet-a"
      cidr = "10.0.13.0/28"
      az   = "eu-west-2a"
    },
    {
      name = "${var.project_name}-public-subnet-b"
      cidr = "10.0.14.0/28"
      az   = "eu-west-2b"
    },
    {
      name = "${var.project_name}-public-subnet-c"
      cidr = "10.0.15.0/28"
      az   = "eu-west-2c"
    }
  ]
}
