resource "aws_vpc" "my_vpc"{
    cidr_block =var.vpc_cidr
    tags ={
        Name ="my_vpc"
    
    }

}

resource "aws_subnet" "publice_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.public_az
    map_customer_owned_ip_on_launch = true
    tags ={
        Name = "private_subnet"
    }

}

resource "aws_subent" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.private_az
    tags ={
        Name ="private_subnet"
    }

}

resource "aws_internet_gateway" "IGW"{
    vpc_id = aws_vpc.my_vpc.id
    tags ={
        Name = "IDW"
    }
}

resource "aws_eip" "nat_eip" {
    subnet_id =aws_subnet.public_subnet.id
    allocation_id = aws_eip.net_eip.id
    tags ={
        Name = "nat_gateway"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW .id
    }

    tags = {
        Name = "public_rt"
    }
  
}

resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt
}

resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id     
    }

    tags = {
        Name = "private_rt"
    }
}

resource "aws_route_table_association" "name" {
  
}