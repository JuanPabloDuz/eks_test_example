resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.instance_tenancy

}

# Subnets
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    count = 2
    cidr_block = var.public_subnet_cidr_blocks[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = "true"
            
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.vpc.id}"

}

# route tables
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }
    tags = {
        Name = "main"
        Main = true
    }
}

# route associations public
resource "aws_route_table_association" "public1" {
    subnet_id = aws_subnet.public[0].id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
    subnet_id = aws_subnet.public[1].id
    route_table_id = aws_route_table.public.id
}