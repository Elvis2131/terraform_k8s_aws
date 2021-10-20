resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "k8s_subnet" {
    for_each = var.vpc-subnet
    vpc_id = aws_vpc.main.id
    cidr_block = each.value["cidr"]
    availability_zone = each.value["availability_zone"]
    map_public_ip_on_launch = each.value["enable_public_ip"]
    tags = each.value["tags"]
}

resource "aws_internet_gateway" "k8s-igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      "Name" = "k8s-vpc-igw"
    }
}

resource "aws_route_table" "public_rw" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s-igw.id
    }

    tags = { "Name" = "k8s-public-subnet-rt" }
}

resource "aws_route_table_association" "k8sPublicrt" {
    subnet_id = aws_subnet.k8s_subnet["public_az"].id
    route_table_id = aws_route_table.public_rw.id
}