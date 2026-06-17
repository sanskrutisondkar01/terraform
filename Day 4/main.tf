resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet_2a" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.public_subnet_cidr_2a
    availability_zone = var.public_az_2a
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "public_subnet_2b" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.public_subnet_cidr_2b
    availability_zone = var.public_az_2b
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet"
    }
}

resource "aws_subnet" "private_subnet_2a" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.private_subnet_cidr_2a
    availability_zone = var.private_az_2a
    tags = {
        Name = "private_subnet"
    }
}

resource "aws_subnet" "private_subnet_2b" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.private_subnet_cidr_2b
    availability_zone = var.private_az_2b
    tags = {
        Name = "private_subnet"
    }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.my_vpc.id 
    tags   = {
        Name = "IGW"
    }
}

resource "aws_eip" "nat_eip" {
    domain = "vpc"
    tags   = {
        Name = "nat_eip"
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    subnet_id = aws_subnet.public_subnet_2a.id 
    allocation_id = aws_eip.nat_eip.id 
    tags = {
        Name = "nat_gateway"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id 
    }

    tags = {
        Name = "public_rt"
    }
}

resource "aws_route_table_association" "public_rt_assoc_2a" {
    subnet_id = aws_subnet.public_subnet_2a.id 
    route_table_id = aws_route_table.public_rt.id 
}

resource "aws_route_table_association" "public_rt_assoc_2b" {
    subnet_id = aws_subnet.public_subnet_2b.id 
    route_table_id = aws_route_table.public_rt.id 
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }

    tags = {
        Name = "private_rt"
    }
}

resource "aws_route_table_association" "private_rt_assoc_2a" {
    subnet_id = aws_subnet.private_subnet_2a.id 
    route_table_id = aws_route_table.private_rt.id 
}

resource "aws_route_table_association" "private_rt_assoc_2b" {
    subnet_id = aws_subnet.private_subnet_2b.id 
    route_table_id = aws_route_table.private_rt.id 
}

resource "aws_security_group" "sg" {
    name = "my-security-group-for-vpc"
    description = "Security group for my VPC"
    vpc_id = aws_vpc.my_vpc.id 

    ingress {
        from_port = 22 
        to_port   = 22 
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port   = 80 
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
        Name = "my-security-group-for-vpc"
    }
}

resource "aws_lb_target_group" "tg" {
    name = "my-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.my_vpc.id 
    health_check {
        path = "/"
    }
}

resource "aws_lb" "lb" {
    name = "ALB"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg.id]
    subnets = [aws_subnet.public_subnet_2a.id, aws_subnet.public_subnet_2b.id]
    tags = {
        Name = "ALB"
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.lb.arn 
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn 
    }
}

resource "aws_launch_template" "lt" {
    name_prefix = "my-launch-template" 
    image_id = var.ami 
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = filebase64("/root/terraform-b30/Day-4/user_data.sh")
}

resource "aws_autoscaling_group" "my_asg" {
    name = "my-asg"
    desired_capacity = var.desired
    min_size = var.min_size
    max_size = var.max_size
    vpc_zone_identifier = [aws_subnet.private_subnet_2a.id, aws_subnet.private_subnet_2b.id]
    target_group_arns = [aws_lb_target_group.tg.arn]
    launch_template {
        id      = aws_launch_template.lt.id
        version = "$Latest"
    }
    health_check_type = "ELB"
}