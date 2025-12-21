resource "aws_ecs_task_definition" "project_name_task" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256" # 0.25 vCPU adjust as you need
  memory                   = "512" # adjust as you need

  container_definitions = jsonencode([
    {
      name = var.service_name
      # smallest possible base image as real image update will happen via another pipeline
      image     = "alpine:latest"
      cpu       = 256 # 0.25 vCPU adjust as you need
      memory    = 512 # adjust as you need
      essential = true
      command   = ["echo", "Hello from Alpine!"]

      portMappings = [
        {
          containerPort = 80
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
      
    ]
  }
}

resource "aws_ecs_service" "project_name_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.project_name_task.arn
  desired_count   = 3
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
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "project_name_ecs_lt" {
  name_prefix   = var.launch_template_name_prefix
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro" # free tier

  iam_instance_profile {
    name = var.instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.launch_template_security_groups_ids
  }

  # this is needed to connect the instance to the ECS cluster
  user_data = base64encode(<<-EOT
              #!/bin/bash
              echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
              EOT
  )
}

output "launch_template_id" {
  value = aws_launch_template.project_name_ecs_lt.id
}
