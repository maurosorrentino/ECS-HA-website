terraform {
  backend "s3" {
    # bucket, key, dynamo table and region is in the terraform init command and 
    # env variable are in .github/workflows/env_vars/dev or prod/env_vars.json
    encrypt        = true
  }
}
