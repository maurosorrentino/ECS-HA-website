resource "aws_ecr_repository" "project_name_ecr_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "project_name_ecr_lc_policy" {
    repository = aws_ecr_repository.project_name_ecr_repo.name

    policy = jsonencode({
        rules = [
            {
                rulePriority = 1
                description  = "Expire untagged images if more than 4 exist"
                selection    = {
                    tagStatus   = "tagged"
                    tagPrefixList: ["v"]
                    countType   = "imageCountMoreThan"
                    countNumber = 4
                }
                action = {
                    type = "expire"
                }
            }
        ]
    })
}
