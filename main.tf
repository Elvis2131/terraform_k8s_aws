provider "aws" {
    region     = "eu-central-1"
    access_key = var.access_key
    secret_key = var.secret_key
}

module "vpc" {
    source     = "./modules/vpc"
}

module "k8s" {
    source     = "./modules/k8s"
}