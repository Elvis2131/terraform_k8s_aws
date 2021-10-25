provider "aws" {
    region     = "us-east-1"
    access_key = var.access_key
    secret_key = var.secret_key
}

module "vpc" { 
    source     = "./modules/vpc" 
    }

module "k8s" { 
    source     = "./modules/k8s" 
    k8s_eks_role_arn = module.iamrole.k8s_eks_role_arn
    k8s_wn_role_arn = module.iamrole.iam_role_worker
    k8s_subnets = module.vpc.subnets
    }

module "iamrole" { source     = "./modules/iamrole" }
module "oidc_role"{
    source = "./modules/oidc_role"
    k8s_cluster_url = module.k8s.cluster_oidc_url
}