variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    default = "10.0.0.0/20"
}

variable "public_az" {
    default = "us-east-2a"
}

variable "private_subnet_cidr" {
    default = "10.0.16.0/20"
}

variable "private_az" {
    default = "us-east-2b"
}

variable "ami" {
    default = "ami-0741dc526e1106ae5"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key_name" {
    default = "web"
}