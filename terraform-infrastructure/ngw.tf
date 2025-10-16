resource "aws_eip" "project_name_elastic_ip" {
  for_each = aws_subnet.project_name_public_subnets
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-elastic-ip-${each.key}"
  }

}

resource "aws_nat_gateway" "project_name_nat_gateway" {
  for_each      = aws_subnet.project_name_public_subnets
  allocation_id = aws_eip.project_name_elastic_ip[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "${var.project_name}-nat-gateway-${each.key}"
  }
}
