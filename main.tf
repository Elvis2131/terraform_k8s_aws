terraform {
  backend "s3"{
      bucket = "tf-bucket021"
      key    = "global/k8s/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "terraform-state-locking"
      encrypt = true
  }
}

resource "aws_s3_bucket" "tf-bucket021" {
    bucket = "tf-bucket021"

    # lifecycle {
    #   prevent_destroy = true
    # }

    versioning {
      enabled = true
    }

    server_side_encryption_configuration {
      rule{
          apply_server_side_encryption_by_default{
              sse_algorithm = "AES256"
          }
      }
    }
}

resource "aws_dynamodb_table" "terraform_locks"{
    name = "terraform-state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}

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