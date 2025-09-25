resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.project_name_vpc.id
    cidr_block              = "10.0.1.0/24" # 256 IPs
    map_public_ip_on_launch = true
    availability_zone       = "${var.region}a"

    tags = {
        Name = "project-name-public-subnet"
    }

    depends_on = [aws_vpc.project_name_vpc]
}

# probably need more subnets in different AZs for HA
resource "aws_subnet" "subnet_private_a" {
    vpc_id            = aws_vpc.project_name_vpc.id
    cidr_block        = "10.0.2.0/24" # 256 IPs
    availability_zone = "${var.region}a"

    tags = {
        Name = "project-name-private-subnet-a"
    }

    depends_on = [aws_vpc.project_name_vpc]
}

resource "aws_subnet" "subnet_private_b" {
    vpc_id            = aws_vpc.project_name_vpc.id
    cidr_block        = "10.0.3.0/24" # 256 IPs
    availability_zone = "${var.region}b"

    tags = {
        Name = "project-name-private-subnet-b"
    }

    depends_on = [aws_vpc.project_name_vpc]
}
