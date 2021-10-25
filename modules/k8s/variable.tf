variable "k8s_eks_role_arn" {}
variable "k8s_wn_role_arn" {}
variable "k8s_subnets" {}
variable "key_name" { default="k8s_kp" }
variable "k8s_version"{ default="1.20"}
variable "publicKey"{ default="C:\\Users\\dell\\.ssh\\id_rsa.pub"}