locals {
  backend_subnets = [
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
    }
  ]

  frontend_subnets = [
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
    }
  ]
}
