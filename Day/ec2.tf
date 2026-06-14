resource "aws_instance" "ec2"  {
    ami  =   "ami-0e38835daf6b8a2b9"
    instance_type = "t3.micro"
    key_name ="terraform"
    vpc_security_group_ids = ["sg-021bd6cb35c4c2623"]
    disable_api_termination = false

    root_block_device {
      volume_size =10
      volume_type = "gp3"
    }
     
    user_data = <<-EOF
                #!/bin/bash
                sudo yum install httpd -y
                sudo systemctl start httpd.service
                sudo systemctl enable httpd.service
                sudo echo "<h1> Hello Apache2! </h1>" > /var/www/html/index.html
                sudo systemctl restart restart httpd.service
                EOF

    tags = {
        Name = "my-instance"
    }
  
}