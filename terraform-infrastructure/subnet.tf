resource "aws_subnet" "project_name_public" {
  vpc_id = aws_vpc.project_name_vpc.id
  # I think I only need one IP for ALB and 1 for nat gateway
  cidr_block              = "10.0.1.0/28" # 16 IPs
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "project-name-public-subnet"
  }

  depends_on = [aws_vpc.project_name_vpc]
}

module "project_name_private_subnet_a_backend" {
  source            = "./modules/subnet"
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.2.0/24" # 256 IPs
  name              = "project-name-backend-private-subnet-${var.region}a"
  depends_on        = [aws_vpc.project_name_vpc]
}

module "project_name_private_subnet_b_backend" {
  source            = "./modules/subnet"
  availability_zone = "${var.region}b"
  cidr_block        = "10.0.4.0/24" # 256 IPs
  name              = "project-name-backend-private-subnet-${var.region}b"
  depends_on        = [aws_vpc.project_name_vpc]
}

module "project_name_private_subnet_c_backend" {
  source            = "./modules/subnet"
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.6.0/24" # 256 IPs
  name              = "project-name-backend-private-subnet-${var.region}c"
  depends_on        = [aws_vpc.project_name_vpc]
}

module "project_name_private_subnet_a_frontend" {
  source            = "./modules/subnet"
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.1.0/24" # 256 IPs
  name              = "project-name-frontend-private-subnet-${var.region}a"
  depends_on        = [aws_vpc.project_name_vpc]
}

module "project_name_private_subnet_b_frontend" {
  source            = "./modules/subnet"
  availability_zone = "${var.region}b"
  cidr_block        = "10.0.3.0/24" # 256 IPs
  name              = "project-name-frontend-private-subnet-${var.region}b"
  depends_on        = [aws_vpc.project_name_vpc]
}

module "project_name_private_subnet_c_frontend" {
  source            = "./modules/subnet"
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.5.0/24" # 256 IPs
  name              = "project-name-frontend-private-subnet-${var.region}c"
  depends_on        = [aws_vpc.project_name_vpc]
}
