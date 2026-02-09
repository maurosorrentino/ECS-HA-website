module "name_project_ecs_frontend_asg" {
  source                              = "./modules/asg"
  asg_name                            = "${var.project_name}-ecs-frontend-asg"
  private_subnet_ids                  = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("frontend", name))]
  launch_template_name_prefix         = "${var.project_name}-ecs-frontend-"
  instance_profile_name               = aws_iam_instance_profile.ecs_instance_profile.name
  launch_template_security_groups_ids = [aws_security_group.project_name_ecs_frontend_service_sg.id]
  cluster_name                        = aws_ecs_cluster.project_name_ecs_cluster.name

  depends_on = [module.project_name_frontend_alb, aws_subnet.project_name_private_subnets, aws_ecs_cluster.project_name_ecs_cluster]
}

module "name_project_ecs_backend_asg" {
  source                              = "./modules/asg"
  asg_name                            = "${var.project_name}-ecs-backend-asg"
  private_subnet_ids                  = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("backend", name))]
  launch_template_name_prefix         = "${var.project_name}-ecs-backend-"
  instance_profile_name               = aws_iam_instance_profile.ecs_instance_profile.name
  launch_template_security_groups_ids = [aws_security_group.project_name_ecs_backend_service_sg.id]
  cluster_name                        = aws_ecs_cluster.project_name_ecs_cluster.name

  depends_on = [module.project_name_backend_alb, aws_subnet.project_name_private_subnets, aws_ecs_cluster.project_name_ecs_cluster]
}
