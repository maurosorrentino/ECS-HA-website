resource "aws_vpc" "project_name_vpc" {
    cidr_block           = "10.0.0.0/16" # over 65k IPs
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "project-name-main-vpc"
    }
}
