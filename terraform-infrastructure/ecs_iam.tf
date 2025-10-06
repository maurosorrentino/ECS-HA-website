resource "aws_iam_role" "project_name_ecs_frontend_role" {
  name = "${var.project_name}-ecs-frontend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "project_name_ecs_frontend_policy" {
  name = "${var.project_name}-ecs-frontend-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.project_name_frontend_service_log_group.arn}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ]
        Resource = [
            module.project_name_frontend_alb.alb_arn,
            module.project_name_backend_alb.alb_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = module.project_name_frontend_cloudwatch_logs_kms.kms_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_frontend_role_attach" {
  role       = aws_iam_role.project_name_ecs_frontend_role.name
  policy_arn = aws_iam_policy.project_name_ecs_frontend_policy.arn
}

resource "aws_iam_instance_profile" "ecs_frontend_profile" {
  name = "${var.project_name}-ecs-frontend-profile"
  role = aws_iam_role.project_name_ecs_frontend_role.name
}
