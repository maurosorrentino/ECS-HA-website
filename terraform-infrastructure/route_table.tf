resource "aws_route_table" "project_name_public_rt" {
    vpc_id = aws_vpc.project_name_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.project_name_igw.id
    }

    tags = {
        Name = "project-name-public-rt"
    }

    depends_on = [aws_internet_gateway.project_name_igw]
}

resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.project_name_public.id
    route_table_id = aws_route_table.project_name_public_rt.id
}

# TODO add private route table and NAT gateway for private subnets
# to do at last as nat isn't covered by free tier 
