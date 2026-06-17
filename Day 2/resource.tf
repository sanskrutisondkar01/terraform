data "aws_vpc" "default" {
    default = true 
}

# data "aws_subnet" "default" {
#     filter {
#         name   = "vpc-id"
#         values = [data.aws_vpc.default.id]
#     }
# }

resource "aws_security_group" "sg" {
    name        = var.sg_name
    description = var.sg_name
    vpc_id      = data.aws_vpc.default.id 

    ingress {
        from_port = var.ingress_ssh
        to_port   = var.ingress_ssh
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.ingress_http
        to_port   = var.ingress_http
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.sg_name
    }
}

resource "aws_instance" "my_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = file("/root/terraform-b30/Day-2/user-data.sh")
    tags = var.tags
}