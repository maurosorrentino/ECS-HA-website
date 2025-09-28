terraform {
  backend "s3" {
    bucket         = "terraform-state-department-name"
    key            = "terraform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    use_lockfile   = true
  }
}
