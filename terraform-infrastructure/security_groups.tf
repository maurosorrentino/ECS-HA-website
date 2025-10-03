data "aws_ip_ranges" "cloudfront" {
  services = ["CLOUDFRONT"]
  regions  = ["GLOBAL"]
}

resource "aws_security_group" "project_name_ecs_frontend_service_sg" {
  name        = "${var.project_name}-ecs-frontend-service-sg"
  description = "ECS service SG: ALB in -> ECS -> private ALB out"
  vpc_id      = aws_vpc.project_name_vpc.id

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_security_group" "project_name_frontend_alb_sg" {
  name        = "${var.project_name}-frontend-alb-sg"
  description = "Allow HTTPS from CloudFront to ALB"
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

resource "aws_security_group_rule" "project_name_frontend_alb_sg_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.project_name_frontend_alb_sg.id
  cidr_blocks       = data.aws_ip_ranges.cloudfront.cidr_blocks
}

resource "aws_security_group_rule" "project_name_frontend_alb_sg_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_frontend_alb_sg.id
  source_security_group_id = aws_security_group.project_name_ecs_frontend_service_sg.id
}

resource "aws_security_group_rule" "project_name_ecs_frontend_service_sg_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.project_name_ecs_frontend_service_sg.id
  source_security_group_id = aws_security_group.project_name_frontend_alb_sg.id
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
