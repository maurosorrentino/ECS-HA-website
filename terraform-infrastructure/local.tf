locals {
  private_subnets = [
    {
      name = "backend-private-subnet-a"
      cidr = "10.0.1.0/24"
      az   = "eu-west-2a"
    },
    {
      name = "backend-private-subnet-b"
      cidr = "10.0.3.0/24"
      az   = "eu-west-2b"
    },
    {
      name = "backend-private-subnet-c"
      cidr = "10.0.5.0/24"
      az   = "eu-west-2c"
    },
    {
      name = "frontend-private-subnet-a"
      cidr = "10.0.2.0/24"
      az   = "eu-west-2a"
    },
    {
      name = "frontend-private-subnet-b"
      cidr = "10.0.4.0/24"
      az   = "eu-west-2b"
    },
    {
      name = "frontend-private-subnet-c"
      cidr = "10.0.6.0/24"
      az   = "eu-west-2c"
    },
    {
      name = "rds-private-subnet-a"
      cidr = "10.0.7.0/24"
      az   = "eu-west-2a"
    },
    {
      name = "rds-private-subnet-b"
      cidr = "10.0.8.0/24"
      az   = "eu-west-2b"
    },
    {
      name = "rds-private-subnet-c"
      cidr = "10.0.9.0/24"
      az   = "eu-west-2c"
    },
    {
      name = "alb-private-subnet-a"
      cidr = "10.0.10.0/24"
      az   = "eu-west-2a"
    }
  ]
}
