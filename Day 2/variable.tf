variable "ami" {
    type = string
    default = "ami-0741dc526e1106ae5"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key_name" {
    default = "web"
}

variable "sg_name" {
    default = "my-security-group-for-default-vpc"
}

variable "ingress_http" {
    default = 80
}

variable "ingress_ssh" {
    default = 22
}

variable "tags" {
    default = {
        Name = "my-instance"
    }
}