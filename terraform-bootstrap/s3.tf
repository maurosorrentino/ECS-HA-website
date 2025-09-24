resource "aws_s3_bucket" "terraform_state" {
    bucket = "${var.ENV}-terraform-state-department-name"
}

resource "aws_dynamodb_table" "terraform_locks" {
    name         = "terraform-lock-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
