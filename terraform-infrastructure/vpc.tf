resource "aws_vpc" "project_name_vpc" {
  # TODO once known change cidr block to something with less IPs
  cidr_block           = "10.0.0.0/16" # over 65k IPs
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_vpc_endpoint" "project_name_s3_alb_logs_vpc_endpoint" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in aws_route_table.private : rt.id]

  tags = {
    Name = "${var.project_name}-s3-alb-logs-vpc-endpoint"
  }

  depends_on = [aws_route_table.private]
}

resource "aws_vpc_endpoint" "project_name_ecr_api" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id
  if can(regex("backend", name))] # backend is in AZs a, b, c
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "${var.project_name}-ecr-api-vpc-endpoint"
  }

  depends_on = [aws_security_group.vpc_endpoints_sg, aws_subnet.project_name_private_subnets]
}

resource "aws_vpc_endpoint" "project_name_ecr_dkr" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id
  if can(regex("backend", name))] # backend is in AZs a, b, c
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "${var.project_name}-ecr-dkr-vpc-endpoint"
  }

  depends_on = [aws_security_group.vpc_endpoints_sg, aws_subnet.project_name_private_subnets]
}

resource "aws_vpc_endpoint" "project_name_cw_logs" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id
  if can(regex("backend", name))] # backend is in AZs a, b, c
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "${var.project_name}-cw-logs-vpc-endpoint"
  }

  depends_on = [aws_security_group.vpc_endpoints_sg, aws_subnet.project_name_private_subnets]
}

resource "aws_vpc_endpoint" "project_name_ssm" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id
  if can(regex("backend", name))] # backend is in AZs a, b, c
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "${var.project_name}-ssm-vpc-endpoint"
  }

  depends_on = [aws_security_group.vpc_endpoints_sg, aws_subnet.project_name_private_subnets]
}

resource "aws_vpc_endpoint" "project_name_ssm_messages" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id
  if can(regex("backend", name))] # backend is in AZs a, b, c
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "${var.project_name}-ssm-messages-vpc-endpoint"
  }

  depends_on = [aws_security_group.vpc_endpoints_sg, aws_subnet.project_name_private_subnets]
}

resource "aws_vpc_endpoint" "project_name_ec2_messages" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id
  if can(regex("backend", name))] # backend is in AZs a, b, c
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "${var.project_name}-ec2-messages-vpc-endpoint"
  }

  depends_on = [aws_security_group.vpc_endpoints_sg, aws_subnet.project_name_private_subnets]
}

# probably don't need the following TODO
resource "aws_vpc_endpoint" "project_name_secretsmanager" {
  vpc_id            = aws_vpc.project_name_vpc.id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id
  if can(regex("backend", name))] # backend is in AZs a, b, c
  security_group_ids = [aws_security_group.vpc_endpoints_sg.id]

  tags = {
    Name = "${var.project_name}-secretsmanager-vpc-endpoint"
  }

  depends_on = [aws_security_group.vpc_endpoints_sg, aws_subnet.project_name_private_subnets]
}
