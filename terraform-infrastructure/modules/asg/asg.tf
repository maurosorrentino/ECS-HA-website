resource "aws_autoscaling_group" "project_name_ecs_asg" {
  name                = var.asg_name
  max_size            = 1 # free tier, change as you need
  min_size            = 1 # free tier, change as you need
  desired_capacity    = 1 # free tier, change as you need
  target_group_arns   = var.target_group_arns
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = var.template_id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
}
