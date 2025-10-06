resource "aws_vpc" "project_name_vpc" {
  # TODO once known change cidr block to something with less IPs
  cidr_block           = "10.0.0.0/16" # over 65k IPs
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_vpc_endpoint" "s3_alb_logs_vpc_endpoint" {
  vpc_id             = aws_vpc.project_name_vpc.id
  service_name       = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type  = "Gateway"
  route_table_ids    = [aws_route_table.private.id]

  tags = {
    Name = "${var.project_name}-s3-alb-logs-vpc-endpoint"
  }

  depends_on = [aws_route_table.private]
}
