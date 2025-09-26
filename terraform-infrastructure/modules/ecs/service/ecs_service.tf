resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = var.task_arn
  desired_count   = 1
  launch_type     = "EC2"

  network_configuration {
    subnets         = var.subnets_ids
    security_groups = var.security_groups_ids
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.service_name
    container_port   = 80
  }
}

output "ecs_task_arn" {
  value = aws_ecs_service.service.arn
}
