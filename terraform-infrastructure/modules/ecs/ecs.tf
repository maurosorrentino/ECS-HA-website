resource "aws_ecs_task_definition" "project_name_task" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256" # 0.25 vCPU adjust as you need
  memory                   = "256" # adjust as you need

  container_definitions = jsonencode([
    {
      name = var.service_name
      # "fake" image as real image update will happen via another pipeline
      image     = "public.ecr.aws/nginx/nginx:latest" # stays alive
      cpu       = 256                                 # 0.25 vCPU adjust as you need
      memory    = 256                                 # adjust as you need
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      log_configuration = {
        log_driver = "awslogs"

        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
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

resource "aws_ecs_service" "project_name_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.project_name_task.arn
  desired_count   = 1 # free tier, change as you need (1 per each AZ)
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.service_name
    container_port   = 80
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = var.task_security_group_ids
  }

  # makes app pipeline fail if there are any issues in updating the service
  deployment_circuit_breaker {
    enable   = true
    rollback = true # automatically go back to the old version on failure
  }
}
