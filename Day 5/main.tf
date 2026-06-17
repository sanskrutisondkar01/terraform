module "vpc" {
    source = "./module/vpc"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidr = "10.0.0.0/24"
    private_subnet_cidr = "10.0.1.0/24"
    public_az = "us-east-2a"
    private_az = "us-east-2b"
}

module "ec2" {
    source = "./module/ec2"
    ami = "ami-0741dc526e1106ae5"
    instance_type = "t3.micro"
    key_name = "web"
    subnet_id = module.vpc.public_subnet_id
    sg_id = module.vpc.sg_id
}