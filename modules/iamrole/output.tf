output "k8s_eks_role_arn" {
    value = aws_iam_role.eksfullpermission.arn
}

output "iam_role_worker" {
    value = aws_iam_role.workernodes.arn
}