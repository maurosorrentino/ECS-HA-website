locals {
  cloudfront_bucket_name = "${var.project_name}-cloudfront-logs"
  alb_bucket_name        = "${var.project_name}-alb-logs"

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
