resource "aws_subnet" "project_name_public_subnet" {
  for_each = { for s in local.public_subnets : s.name => s }

  vpc_id                  = aws_vpc.project_name_vpc.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true
  availability_zone       = each.value.az

  tags = {
    Name = each.value.name
  }
  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_subnet" "private_subnets" {
  for_each = { for s in local.private_subnets : s.name => s }

  vpc_id            = aws_vpc.project_name_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
  depends_on = [aws_vpc.project_name_vpc]
}
