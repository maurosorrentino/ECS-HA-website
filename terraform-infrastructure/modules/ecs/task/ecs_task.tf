resource "aws_ecs_task_definition" "project_name_task" {
  family                   = var.task_name
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256" # 0.25 vCPU
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name = var.task_name
      # smallest possible base image as real image update will happen via another pipeline
      image     = "alpine:latest"
      cpu       = 256 # 0.25 vCPU
      memory    = 512
      essential = true
      command   = ["echo", "Hello from Alpine!"]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  # image update will happen in another pipeline, this is to avoid terraform trying to update it
  # with "fake" image
  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}

output "ecs_task_arn" {
  value = aws_ecs_task_definition.project_name_task.arn
}
