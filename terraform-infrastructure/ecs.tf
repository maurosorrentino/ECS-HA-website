resource "aws_ecs_cluster" "project_name_ecs_cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "project_name_frontend_ecs_service" {
  source                  = "./modules/ecs"
  service_name            = var.frontend_service_name
  cluster_id              = aws_ecs_cluster.project_name_ecs_cluster.id
  alb_target_group_arn    = module.project_name_frontend_alb.target_group_arn
  log_group_name          = aws_cloudwatch_log_group.project_name_frontend_service_log_group.name
  region                  = var.region
  task_security_group_ids = [aws_security_group.project_name_ecs_task_sg.id]
  private_subnet_ids      = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("frontend", name))]

  depends_on = [module.project_name_frontend_alb, aws_security_group.project_name_ecs_frontend_service_sg,
    aws_cloudwatch_log_group.project_name_frontend_service_log_group, aws_security_group.project_name_ecs_task_sg,
  aws_iam_role.frontend_task_role]
}

module "project_name_backend_ecs_service" {
  source                  = "./modules/ecs"
  service_name            = var.backend_service_name
  cluster_id              = aws_ecs_cluster.project_name_ecs_cluster.id
  alb_target_group_arn    = module.project_name_backend_alb.target_group_arn
  log_group_name          = aws_cloudwatch_log_group.project_name_backend_service_log_group.name
  region                  = var.region
  task_security_group_ids = [aws_security_group.project_name_ecs_task_sg.id]
  private_subnet_ids      = [for name, subnet in aws_subnet.project_name_private_subnets : subnet.id if can(regex("backend", name))]

  depends_on = [module.project_name_backend_alb, aws_security_group.project_name_ecs_backend_service_sg,
    aws_cloudwatch_log_group.project_name_backend_service_log_group, aws_security_group.project_name_ecs_task_sg,
  aws_iam_role.backend_task_role]
}
