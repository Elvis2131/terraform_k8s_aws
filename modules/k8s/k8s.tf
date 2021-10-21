resource "aws_eks_cluster" "k8s_cluster" {
    name = "k8s-tf"
    role_arn = var.k8s_eks_role_arn
    endpoint_public_access = true
    endpoint_private_access = true

    vpc_config {
      subnet_ids = var.k8s_subnets
    }
}