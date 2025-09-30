data "aws_ip_ranges" "cloudfront" {
  services = ["CLOUDFRONT"]
  regions  = ["GLOBAL"]
}

resource "aws_security_group" "ecs_frontend_service_sg" {
  name        = "${var.project_name}-ecs-frontend-service-sg"
  description = "ECS service SG: ALB in -> ECS -> private ALB out"
  vpc_id      = aws_vpc.project_name_vpc.id

  ingress {
    description     = "Allow HTTP from public ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_alb_sg.id]
  }

  egress {
    description     = "Allow ECS to send HTTP to private ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_alb_sg.id]
  }
}

resource "aws_security_group" "frontend_alb_sg" {
  name        = "${var.project_name}-frontend-alb-sg"
  description = "Allow HTTPS from CloudFront to ALB"
  vpc_id      = aws_vpc.project_name_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [for range in data.aws_ip_ranges.cloudfront.cidr_blocks : range]
  }

  egress {
    description     = "Allow ALB to ECS only on port 80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_frontend_service_sg.id]
  }

  depends_on = [aws_vpc.project_name_vpc, aws_cloudfront_distribution.project_name_cdn] #TODO
}

resource "aws_security_group" "backend_alb_sg" {
  name        = "${var.project_name}-backend-alb-sg"
  description = "Allow HTTP from ECS service to backend ALB"
  vpc_id      = aws_vpc.project_name_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_frontend_service_sg.id]
  }

  egress {
    description     = "Allow HTTP ALB to ECS backend service"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  depends_on = [aws_vpc.project_name_vpc, aws_cloudfront_distribution.project_name_cdn] #TODO
}

resource "aws_security_group" "ecs_backend_service_sg" {
  name        = "${var.project_name}-ecs-backend-service-sg"
  description = "backend ECS service to RDS"
  vpc_id      = aws_vpc.project_name_vpc.id

  ingress {
    description     = "Allow HTTP from private ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_alb_sg.id]
  }

  egress {
    description     = "Allow traffic to RDS"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_sg.id]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "RDS security group"
  vpc_id      = aws_vpc.project_name_vpc.id

  ingress {
    description     = "Allow traffic from ECS backend service"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_backend_service_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
