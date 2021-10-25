resource "aws_eks_cluster" "k8s_cluster" {
    name = "k8s-tf"
    role_arn = var.k8s_eks_role_arn
    
    version = var.k8s_version

    vpc_config {
      subnet_ids = var.k8s_subnets
      endpoint_public_access = true
      endpoint_private_access = true
    }
}

resource "aws_eks_node_group" "eksNodes" {
    cluster_name = aws_eks_cluster.k8s_cluster.name
    node_group_name = "k8s_nodes"

    node_role_arn = var.k8s_wn_role_arn
    subnet_ids =  [var.k8s_subnets[0], var.k8s_subnets[1]]

    scaling_config {
      desired_size = 1
      max_size = 5
      min_size = 1
    }

    remote_access{
      ec2_ssh_key = aws_key_pair.workerNodeskp.id
    }
}

resource "aws_key_pair" "workerNodeskp" {
    key_name = var.key_name
    public_key = file(var.publicKey)
}