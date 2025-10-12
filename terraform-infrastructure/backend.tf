terraform {
  backend "s3" {
    # bucket key and region is in the terraform init command and env variable are in .github/workflows/ENV/env_vars.json
    encrypt        = true
  }
}
