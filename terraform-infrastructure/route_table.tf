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
  for_each = aws_nat_gateway.project_name_nat_gateway

  vpc_id = aws_vpc.project_name_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${each.key}"
  }

  depends_on = [aws_vpc.project_name_vpc, aws_nat_gateway.project_name_nat_gateway]
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.project_name_private_subnets

  subnet_id      = each.value.id
  # association to nat gateway in the same AZ
  route_table_id = aws_route_table.private[aws_subnet.project_name_private_subnets[each.key].availability_zone].id

  depends_on = [aws_subnet.project_name_private_subnets]
}
