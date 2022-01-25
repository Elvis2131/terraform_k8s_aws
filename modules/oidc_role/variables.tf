variable "k8s_cluster_url"{}
variable "k8s_cluster_noprefix"{}
variable "k8s_namespace" { default="kube-system"}
variable "k8s_service_account" { default="cluster-autoscaler"}
variable "asc_role_name" { default="k8s_auto-scaling_role"}