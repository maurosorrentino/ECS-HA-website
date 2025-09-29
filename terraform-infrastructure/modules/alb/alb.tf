resource "aws_lb" "project_name_alb" {
  name                       = var.alb_name
  internal                   = false # cloudfront in front of it
  load_balancer_type         = "application"
  security_groups            = var.alb_security_groups
  subnets                    = var.alb_subnets
  enable_deletion_protection = true
  idle_timeout               = 60
  drop_invalid_header_fields = true
}

resource "aws_lb_target_group" "project_name_tg" {
  name     = var.alb_target_group_name
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  target_type = "instance"
}

resource "aws_lb_listener" "project_name_listener_https" {
  load_balancer_arn = aws_lb.project_name_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_name_tg.arn
  }
}

output "alb_dns_name" {
  value = aws_lb.project_name_alb.dns_name
}
