resource "aws_ecs_cluster" "project_name_ecs_cluster" {
  name = "${var.project_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "frontend_ecs_task" {
  source    = "./modules/task/ecs"
  task_name = "frontend"
}

module "backend_ecs_task" {
  source    = "./modules/task/ecs"
  task_name = "backend"
}

# TODO ALB, sg
module "frontend_ecs_service" {
  source                = "./modules/service/ecs"
  service_name          = "frontend"
  cluster_id            = aws_ecs_cluster.project_name_ecs_cluster.id
  task_arn              = module.frontend_ecs_task.ecs_task_arn
  subnets_ids           = [ for name, subnet in aws_subnet.private_subnets : subnet.id if contains(name, "frontend") ]
  security_groups_ids   = #TODO
  alb_target_group_arn  = aws_lb_target_group.project_name_frontend_tg.arn

  depends_on = [aws_subnet.private_subnets, alb_target_group, sg] #TODO
}
