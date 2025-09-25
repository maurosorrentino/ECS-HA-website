resource "aws_subnet" "subnet_private" {
    vpc_id            = aws_vpc.project_name_vpc.id
    cidr_block        = var.cidr_block
    availability_zone = var.availability_zone

    tags = {
        Name = var.name
    }
}
