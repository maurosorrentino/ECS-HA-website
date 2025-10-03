resource "aws_ecs_task_definition" "project_name_task" {
  family                   = var.service_name
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256" # 0.25 vCPU
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name = var.service_name
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

resource "aws_ecs_service" "project_name_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.project_name_task.arn
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
  instance_type = "t2.micro" # free tier

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
