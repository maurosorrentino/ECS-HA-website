resource "aws_subnet" "project_name_public" {
  vpc_id = aws_vpc.project_name_vpc.id
  # I think I only need one IP for ALB and 1 for nat gateway
  cidr_block              = "172.0.1.0/28" # 16 IPs
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "project-name-public-subnet"
  }

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_subnet" "backend_private_subnets" {
  for_each = { for s in local.backend_subnets : s.name => s }

  vpc_id                  = aws_vpc.project_name_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az

  tags = {
    Name = each.value.name
  }
  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_subnet" "frontend_private_subnets" {
  for_each = { for s in local.frontend_subnets : s.name => s }

  vpc_id                  = aws_vpc.project_name_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az

  tags = {
    Name = each.value.name
  }
  depends_on = [aws_vpc.project_name_vpc]
}
