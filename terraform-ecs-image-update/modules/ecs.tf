data "aws_ecs_task_definition" "current_task_definition" {
  task_definition = var.service_name
}

resource "aws_ecs_task_definition" "new_task_definition" {
  family                   = data.aws_ecs_task_definition.current_task_definition.family
  network_mode             = data.aws_ecs_task_definition.current_task_definition.network_mode
  cpu                      = data.aws_ecs_task_definition.current_task_definition.cpu
  memory                   = data.aws_ecs_task_definition.current_task_definition.memory
  requires_compatibilities = data.aws_ecs_task_definition.current_task_definition.requires_compatibilities
  execution_role_arn       = data.aws_ecs_task_definition.current_task_definition.execution_role_arn
  task_role_arn            = data.aws_ecs_task_definition.current_task_definition.task_role_arn

  container_definitions = jsonencode([
    for c in jsondecode(data.aws_ecs_task_definition.current_task_definition.container_definitions) : merge(c, {
      image = var.image_uri
    })
  ])
}

resource "aws_ecs_service" "update" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.new_task_definition.arn

  force_new_deployment = true
}
