resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.GITHUB_THUMBPRINT]
}

resource "aws_iam_role" "github_actions_role" {
  name = "${var.ENV}GitHubActionsProjectNameRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.GITHUB_REPO}:ref:refs/tags/v*",
            "repo:${var.GITHUB_REPO}:environment:*"
          ]
        }
      }
    }]
  })
}

# TODO once finished make a role for gh actions that deploys only resources needed
resource "aws_iam_role_policy_attachment" "github_actions_policy_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
