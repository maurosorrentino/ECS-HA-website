resource "aws_autoscaling_group" "project_name_ecs_asg" {
  name                = var.asg_name
  max_size            = 20
  min_size            = 10
  desired_capacity    = 15
  target_group_arns   = var.target_group_arns
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = var.template_id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
}
