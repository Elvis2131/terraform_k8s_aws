output "cluster_oidc_url"{
    value = aws_eks_cluster.k8s_cluster.identity.0.oidc.0.issuer
}