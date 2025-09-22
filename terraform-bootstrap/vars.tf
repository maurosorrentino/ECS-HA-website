variable "ENV" {
  description = "The deployment environment (dev, prod)"
  type        = string
  default     = "dev"
}

variable "REGION" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-west-2"
}

variable "GITHUB_THUMBPRINT" {
  description = "The GitHub OIDC thumbprint"
  type        = string
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}
