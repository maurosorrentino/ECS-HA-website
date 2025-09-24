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
  default     = "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
}

variable "GITHUB_REPO" {
  description = "The GitHub repository in the format owner/repo"
  type        = string
  default     = "maurosorrentino/ECS-HA-failover-website"
}
