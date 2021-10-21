output "iam_role_eks" {
    value = aws_iam_role.eksfullpermission.id
}

output "iam_role_worker" {
    value = aws_iam_role.workernodes.id
}