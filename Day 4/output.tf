output "vpc_id" {
    value = aws_vpc.my_vpc.id 
}

output "sg_id" {
    value = aws_security_group.sg.id 
}

output "elastic_ip" {
    value = aws_eip.nat_eip.public_ip
}

output "load_balancer_dns" {
    value = aws_lb.lb.dns_name
}