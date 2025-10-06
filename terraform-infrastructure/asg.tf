module "name_project_ecs_frontend_asg" {
  source             = "./modules/asg"
  asg_name           = "${var.project_name}-ecs-frontend-asg"
  private_subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("frontend", name))]
  template_id        = module.project_name_frontend_ecs_service.launch_template_id
  target_group_arns  = [module.project_name_frontend_alb.alb_target_group_arn]

  depends_on = [module.project_name_frontend_alb, aws_subnet.project_name_private_subnets]
}

module "name_project_ecs_backend_asg" {
  source             = "./modules/asg"
  asg_name           = "${var.project_name}-ecs-backend-asg"
  private_subnet_ids = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("backend", name))]
  template_id        = module.project_name_backend_ecs_service.launch_template_id
  target_group_arns  = [module.project_name_backend_alb.alb_target_group_arn]

  depends_on = [module.project_name_backend_alb, aws_subnet.project_name_private_subnets]
}
