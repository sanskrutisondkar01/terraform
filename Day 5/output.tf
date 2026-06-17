output "public_ip" {
    value = module.ec2.public_ip
}

output "public_subnet_id" {
    value = module.vpc.public_subnet_id
}

output "sg_id" {
    value = module.vpc.sg_id
}
