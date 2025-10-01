terraform {
  backend "s3" {
    bucket         = "terraform-state-department-name"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
