resource "aws_route_table" "project_name_public_rt" {
  vpc_id = aws_vpc.project_name_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_name_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }

  depends_on = [aws_internet_gateway.project_name_igw, aws_vpc.project_name_vpc]
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.project_name_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.project_name_public_rt.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.project_name_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project_name_nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_route_table_association" "private" {
  for_each = {
    for name, subnet in aws_subnet.project_name_private_subnets : name => subnet.id if can(regex("alb", name))
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id

  depends_on = [aws_subnet.project_name_private_subnets]
}
