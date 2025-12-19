resource "aws_security_group" "project_name_ecs_frontend_service_sg" {
  name        = "${var.project_name}-ecs-frontend-service-sg"
  description = "ECS service SG: ALB in ECS private ALB out"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_frontend_alb_ipv4_sg" {
  name        = "${var.project_name}-frontend-alb-ipv4-sg"
  description = "Allow HTTPS from CloudFront to ALB via ipv4"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_frontend_alb_ipv6_sg" {
  name        = "${var.project_name}-frontend-alb-ipv6-sg"
  description = "Allow HTTPS from CloudFront to ALB via ipv6"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_backend_alb_sg" {
  name        = "${var.project_name}-backend-alb-sg"
  description = "Allow HTTP from ECS service to backend ALB"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "RDS security group"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_ecs_backend_service_sg" {
  name        = "${var.project_name}-ecs-backend-service-sg"
  description = "backend ECS service to RDS"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_ecr_vpc_endpoint_sg" {
  name        = "${var.project_name}-ecr-vpc-endpoint-sg"
  description = "Allow ECS launch templates to access ECR via VPC endpoint"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_ecs_task_sg" {
  name        = "${var.project_name}-ecs-task-sg"
  description = "SG for ECS task: access ECR and internet via NAT"
  vpc_id      = aws_vpc.project_name_vpc.id

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.project_name_ecr_vpc_endpoint_sg.id]
    description     = "Allow outbound HTTPS to ECR via VPC endpoint"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic to the internet via NAT"
  }

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "${var.project_name}-vpc-endpoints-sg"
  description = "Allow ECS tasks to reach interface VPC endpoints"
  vpc_id      = aws_vpc.project_name_vpc.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    security_groups = [aws_security_group.project_name_ecs_backend_service_sg.id,
    aws_security_group.project_name_ecs_frontend_service_sg.id]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "project_name_frontend_alb_ipv4_sg_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.project_name_frontend_alb_ipv4_sg.id
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront_ipv4_prefix_list.id]
}

resource "aws_security_group_rule" "project_name_frontend_alb_ipv6_sg_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.project_name_frontend_alb_ipv6_sg.id
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront_ipv6_prefix_list.id]
}

resource "aws_security_group_rule" "project_name_frontend_alb_ipv4_sg_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_frontend_alb_ipv4_sg.id
  source_security_group_id = aws_security_group.project_name_ecs_frontend_service_sg.id
}

resource "aws_security_group_rule" "project_name_ecs_frontend_service_sg_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_ecs_frontend_service_sg.id
  source_security_group_id = aws_security_group.project_name_frontend_alb_ipv4_sg.id
}

resource "aws_security_group_rule" "project_name_ecs_frontend_service_sg_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_ecs_frontend_service_sg.id
  source_security_group_id = aws_security_group.project_name_backend_alb_sg.id
}

resource "aws_security_group_rule" "project_name_backend_alb_sg_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_backend_alb_sg.id
  source_security_group_id = aws_security_group.project_name_ecs_frontend_service_sg.id
}

resource "aws_security_group_rule" "project_name_backend_alb_sg_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_backend_alb_sg.id
  source_security_group_id = aws_security_group.project_name_ecs_backend_service_sg.id
}

resource "aws_security_group_rule" "project_name_ecs_backend_service_sg_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_ecs_backend_service_sg.id
  source_security_group_id = aws_security_group.project_name_backend_alb_sg.id
}

resource "aws_security_group_rule" "project_name_ecs_backend_service_sg_egress" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_ecs_backend_service_sg.id
  source_security_group_id = aws_security_group.project_name_rds_sg.id
}

resource "aws_security_group_rule" "project_name_rds_sg_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_rds_sg.id
  source_security_group_id = aws_security_group.project_name_ecs_backend_service_sg.id
}
