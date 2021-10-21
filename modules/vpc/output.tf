output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnets" {
    value = [
        aws_subnet.k8s_subnet["private_az_one"].id, 
        aws_subnet.k8s_subnet["private_az_two"].id,
        aws_subnet.k8s_subnet["public_az"].id]
}