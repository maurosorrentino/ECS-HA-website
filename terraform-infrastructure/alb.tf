module "project_name_frontend_alb" {
  source                = "./modules/alb"
  alb_name              = "${var.project_name}-frontend-alb"
  alb_target_group_name = "${var.project_name}-frontend-tg"
  vpc_id                = aws_vpc.project_name_vpc.id
  alb_security_groups   = [aws_security_group.project_name_frontend_alb_ipv4_sg.id, aws_security_group.project_name_frontend_alb_ipv6_sg.id]
  alb_subnets           = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("alb", name))]
  bucket_id             = module.project_name_alb_logs_s3.bucket_id
  s3_prefix             = local.s3_frontend_alb_prefix
  listener_port = 443

  depends_on = [aws_subnet.project_name_private_subnets, aws_security_group.project_name_frontend_alb_ipv4_sg,
  module.project_name_alb_logs_s3, aws_s3_bucket_policy.alb_logs_policy, aws_security_group.project_name_frontend_alb_ipv6_sg]
}

module "project_name_backend_alb" {
  source                = "./modules/alb"
  alb_name              = "${var.project_name}-backend-alb"
  alb_target_group_name = "${var.project_name}-backend-tg"
  vpc_id                = aws_vpc.project_name_vpc.id
  alb_security_groups   = [aws_security_group.project_name_backend_alb_sg.id]
  alb_subnets           = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("alb", name))]
  bucket_id             = module.project_name_alb_logs_s3.bucket_id
  s3_prefix             = local.s3_backend_alb_prefix
  listener_port = 80

  depends_on = [aws_subnet.project_name_private_subnets, aws_security_group.project_name_backend_alb_sg,
  module.project_name_alb_logs_s3, aws_s3_bucket_policy.alb_logs_policy]
}
