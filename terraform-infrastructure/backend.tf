terraform {
  backend "s3" {
    bucket         = "${var.ENV}-terraform-state-department-name"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    use_lockfile   = true
  }
}
