resource "aws_lb" "project_name_frontend_alb" {
  name               = "frontend-alb"
  internal           = false # cloudfront in front of it
  load_balancer_type = "application"
  security_groups    = # TODO https from cloudfront
  subnets            = [aws_subnet.project_name_public_subnet.id] # TODO 3 public subnets

  enable_deletion_protection = false
  idle_timeout               = 60
  drop_invalid_header_fields = true

  tags = {
    Name = "${var.project_name}-frontend-alb"
  }

  depends_on = [aws_subnet.project_name_public_subnet, sg]
}

resource "aws_lb_target_group" "project_name_frontend_tg" {
  name     = "${var.project_name}-frontend-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.project_name_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  target_type = "instance"

  depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_lb_listener" "project_name_listener_https" {
  load_balancer_arn = aws_lb.project_name_frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_name_frontend_tg.arn
  }
}
