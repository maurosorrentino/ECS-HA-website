resource "aws_vpc" "project_name_vpc" {
  # TODO once known change cidr block to something with less IPs
  cidr_block           = "10.0.0.0/16" # over 65k IPs
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}
