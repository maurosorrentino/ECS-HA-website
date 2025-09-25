resource "aws_internet_gateway" "project_name_igw" {
  vpc_id = aws_vpc.project_name_vpc.id

  tags = {
    Name = "project-name-igw"
  }

  depends_on = [aws_vpc.project_name_vpc]
}
