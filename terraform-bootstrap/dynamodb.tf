resource "aws_dynamodb_table" "terraform_lock_infra" {
    name         = "terraform-infra-lock-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

resource "aws_dynamodb_table" "terraform_lock_app" {
    name         = "terraform-app-lock-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
