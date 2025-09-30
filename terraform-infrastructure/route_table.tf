resource "aws_route_table" "project_name_public_rt" {
  vpc_id = aws_vpc.project_name_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_name_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }

  depends_on = [aws_internet_gateway.project_name_igw]
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.project_name_public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.project_name_public_rt.id
}

# TODO add private route table and NAT gateway for private subnets
# to do at last as nat isn't covered by free tier 
