# TODO module
# TODO if I'm not mistaken I need permissions for SSM
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

  depends_on = [module.project_name_frontend_cloudwatch_logs_kms, module.project_name_frontend_alb,
  module.project_name_backend_alb, aws_cloudwatch_log_group.project_name_frontend_service_log_group]
}

resource "aws_iam_role_policy_attachment" "project_name_ecs_frontend_role_attach" {
  role       = aws_iam_role.project_name_ecs_frontend_role.name
  policy_arn = aws_iam_policy.project_name_ecs_frontend_policy.arn
}

resource "aws_iam_instance_profile" "project_name_ecs_frontend_profile" {
  name = "${var.project_name}-ecs-frontend-profile"
  role = aws_iam_role.project_name_ecs_frontend_role.name
}

###################################################################################################################
###################################################################################################################
# backend

resource "aws_iam_role" "project_name_ecs_backend_role" {
  name = "${var.project_name}-ecs-backend-role"

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

resource "aws_iam_policy" "project_name_ecs_backend_policy" {
  name = "${var.project_name}-ecs-backend-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.project_name_backend_service_log_group.arn}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = module.project_name_backend_cloudwatch_logs_kms.kms_arn
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = data.aws_secretsmanager_secret_version.project_name_rds_instance_username.arn
      },
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect"
        ]
        Resource = aws_db_instance.project_name_rds_instance.arn
      }
    ]
  })

  depends_on = [aws_db_instance.project_name_rds_instance, data.aws_secretsmanager_secret_version.project_name_rds_instance_username,
  aws_cloudwatch_log_group.project_name_backend_service_log_group]
}

resource "aws_iam_role_policy_attachment" "project_name_ecs_backend_role_attach" {
  role       = aws_iam_role.project_name_ecs_backend_role.name
  policy_arn = aws_iam_policy.project_name_ecs_backend_policy.arn
}

resource "aws_iam_instance_profile" "project_name_ecs_backend_profile" {
  name = "${var.project_name}-ecs-backend-profile"
  role = aws_iam_role.project_name_ecs_backend_role.name
}
