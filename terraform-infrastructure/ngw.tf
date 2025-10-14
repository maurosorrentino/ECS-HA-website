resource "aws_eip" "project_name_elastic_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "project_name_nat_gateway" {
  for_each      = aws_subnet.project_name_public_subnets
  allocation_id = aws_eip.project_name_elastic_ip.id
  subnet_id     = each.value.id
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}
