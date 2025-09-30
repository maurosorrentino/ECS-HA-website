resource "aws_ecs_cluster" "project_name_ecs_cluster" {
  name = "${var.project_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "project_name_frontend_ecs_task" {
  source    = "./modules/ecs/task"
  task_name = "frontend"
}

module "project_name_backend_ecs_task" {
  source    = "./modules/ecs/task"
  task_name = "backend"
}

module "project_name_frontend_ecs_service" {
  source               = "./modules/ecs/service"
  service_name         = "frontend"
  cluster_id           = aws_ecs_cluster.project_name_ecs_cluster.id
  task_arn             = module.project_name_frontend_ecs_task.ecs_task_arn
  subnets_ids          = [for name, subnet in aws_subnet.private_subnets : subnet.id if contains(name, "frontend")]
  security_groups_ids  = [aws_security_group.ecs_frontend_service_sg.id]
  alb_target_group_arn = module.project_name_frontend_alb.target_group_arn

  depends_on = [aws_subnet.private_subnets, module.project_name_frontend_alb, aws_security_group.ecs_frontend_service_sg]
}

module "project_name_backend_ecs_service" {
  source               = "./modules/ecs/service"
  service_name         = "backend"
  cluster_id           = aws_ecs_cluster.project_name_ecs_cluster.id
  task_arn             = module.project_name_backend_ecs_task.ecs_task_arn
  subnets_ids          = [for name, subnet in aws_subnet.private_subnets : subnet.id if contains(name, "backend")]
  security_groups_ids  = [aws_security_group.ecs_backend_service_sg.id]
  alb_target_group_arn = module.project_name_backend_alb.target_group_arn

  depends_on = [aws_subnet.private_subnets, module.project_name_backend_alb, aws_security_group.ecs_backend_service_sg]

}
