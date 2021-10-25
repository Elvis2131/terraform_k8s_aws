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

data "external" "thumb" {
  program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", aws_eks_cluster.k8s_cluster.identity.0.oidc.0.issuer]
}

resource "aws_iam_openid_connect_provider" "k8s_tf" {
  url = aws_eks_cluster.k8s_cluster.identity.0.oidc.0.issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.external.thumb.result.thumbprint]
}

resource "aws_iam_role" "k8s_role" {
  name = "test-role"

  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.k8s_tf.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${aws_eks_cluster.k8s_cluster.identity.0.oidc.0.issuer}:sub": "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account}"
        }
      }
    }
  ]
})
}

resource "aws_iam_policy" "k8s_autoscaler_policy"{
    name = "k8s-auto-scaler-policy"

    policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": [
              "autoscaling:DescribeAutoScalingGroups",
              "autoscaling:DescribeAutoScalingInstances",
              "autoscaling:DescribeLaunchConfigurations",
              "autoscaling:DescribeTags",
              "autoscaling:SetDesiredCapacity",
              "autoscaling:TerminateInstanceInAutoScalingGroup",
              "ec2:DescribeLaunchTemplateVersions"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
  ]
})
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.k8s_role.name
  policy_arn = aws_iam_policy.k8s_autoscaler_policy.arn
}