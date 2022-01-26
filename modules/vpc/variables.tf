variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_name" {
    type = string
    default = "CustomVPC"
}

variable "vpc-subnet" {
    type = map(object(
        {
            cidr = string
            tags = map(string)
            enable_public_ip = bool
            availability_zone = string
            private_dns_hostname_type_on_launch = string
        }
    ))
    default = {
      "private_az_one" = {
        availability_zone = "us-east-1a"
        cidr = "10.0.64.0/24"
        enable_public_ip = false
        private_dns_hostname_type_on_launch = "resource-name"
        tags = {
          "Name" = "k8s-private-az-two"
        }
      }
      "private_az_two" ={
        availability_zone = "us-east-1b"
        cidr = "10.0.128.0/24"
        private_dns_hostname_type_on_launch = "resource-name"
        enable_public_ip = false
        tags = {
          "Name" = "k8s-private-az-one"
        }
      }
      "public_az"={
        availability_zone = "us-east-1c"
        enable_public_ip = true
        private_dns_hostname_type_on_launch = "resource-name"
        cidr = "10.0.192.0/24"
        tags = {
          "Name" = "k8s-public-az"
        } 
      }
    }
}