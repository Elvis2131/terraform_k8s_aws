variable "k8s_eks_role_arn" {}
variable "k8s_wn_role_arn" {}
variable "k8s_subnets" {}
variable "key_name" { default="k8s_kp" }

variable "k8s_version"{ default="1.20"}

variable "worker_node_instance_type"{ default = "t3.medium" }

variable "worker_node_lt_name" { default = "k8s_worker_nodes" }

variable "lt_ami_arn" { default = "ami-02e136e904f3da870" }