data "external" "thumb" {
  program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", var.k8s_cluster_url]
}

resource "aws_iam_openid_connect_provider" "k8s_tf" {
  url = var.k8s_cluster_url

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.external.thumb.result.thumbprint]
}

resource "aws_iam_role" "k8s_role" {
  name = var.asc_role_name

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
          "${var.k8s_cluster_url}:sub": "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account}"
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