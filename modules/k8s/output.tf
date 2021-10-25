output "cluster_oidc_url"{
    value = aws_eks_cluster.k8s_cluster.identity.0.oidc.0.issuer
}

output "cluster_endpoint"{
    value = aws_eks_cluster.k8s_cluster.endpoint
}

output "cluster_certificate_authority"{
    value = aws_eks_cluster.k8s_cluster.certificate_authority[0].data
}

output "cluster-name"{
    value = aws_eks_cluster.k8s_cluster.name
}