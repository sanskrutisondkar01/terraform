data "aws_vpc" "default" {
    default = true
  
}

resource "aws_instance" "my_ec2" {
    ami  = "ami-0e38835daf6b8a2b9"
    instance_type = "t3.micro"
    key_name = "terraform"
    vpc_security_group_ids = [aws_security_group.sg.id]
    disable_api_termination = false
    user_data  = file("/root/terraform/Day-1/user-data.sh")
    depends_on = [aws_security_group.sg]
    root_block_device {
      volume_size = 10
      volume_type = "gp3"
    }

    tags = {
        Name = "my_ec2"
    }

    
}
