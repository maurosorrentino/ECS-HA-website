module "project_name_frontend_alb" {
  source                = "./modules/alb"
  alb_name              = "${var.project_name}-frontend-alb"
  alb_target_group_name = "${var.project_name}-frontend-tg"
  vpc_id                = aws_vpc.project_name_vpc.id
  alb_security_groups   = [aws_security_group.frontend_alb_sg.id]
  alb_subnets           = [for name, subnet in aws_subnet.project_name_public_subnets : subnet.id]

  depends_on = [aws_subnet.project_name_public_subnet, aws_security_group.frontend_alb_sg]
}
