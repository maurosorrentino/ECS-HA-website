terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
    use_lockfile   = true
  }
}
