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
  instance_type = "t3.micro"

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

              # remove the following if you have a critical workload
              echo ECS_ENABLE_SPOT_INSTANCE_DRAINING=true >> /etc/ecs/ecs.config
              EOT
  )
}

resource "aws_autoscaling_group" "project_name_ecs_asg" {
  name                = var.asg_name
  max_size            = 1 # free tier, change as you need
  min_size            = 1 # free tier, change as you need
  desired_capacity    = 1 # free tier, change as you need
  vpc_zone_identifier = var.private_subnet_ids

  # remove the following if not using spot instances
  mixed_instances_policy {
    instances_distribution {
      # 0 means use Spot for everything. 
      # Set to 1 if you want at least one guaranteed On-Demand instance.
      on_demand_base_capacity                  = 0 
      on_demand_percentage_above_base_capacity = 0 
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.project_name_ecs_lt.id
        version            = "$Latest"
      }
    }
  }

  # keep the following if not using spot instances
  # launch_template {
  #   id      = aws_launch_template.project_name_ecs_lt.id
  #   version = "$Latest"
  # }

  health_check_type         = "EC2"
  health_check_grace_period = 300
}

resource "aws_autoscaling_policy" "project_name_asg_cpu_target" {
  name                   = "${var.asg_name}-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.project_name_ecs_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80
  }
}
