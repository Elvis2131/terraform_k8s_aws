output "vpc_id" {
    value = aws_vpc.main.vpc_id
}

output "subnets" {
    value = aws_subnet.k8s_subnet[*]
}