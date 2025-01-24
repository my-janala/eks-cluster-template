terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Backend configuration
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "env-template-repo/staging/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "your-lock-table"
  }
}

# Networking Module
module "networking" {
  source = "git::https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/env-networking-module?ref=master"

  vpc_name                     = "env-vpc"
  vpc_cidr                     = "192.168.0.0/16"
  control_plane_subnet_cidr    = "192.168.1.0/24"
  worker_nodes_subnet_cidr     = "192.168.2.0/24"
  pod_services_subnet_cidr_1   = "192.168.3.0/24"
  pod_services_subnet_cidr_2   = "192.168.4.0/24"
  outpost_arn                  = "arn:aws:outposts:region:account:outpost/outpost-id"
  service_link_endpoint_id     = "vpce-12345678"
  local_gateway_id             = "lgw-12345678"
  on_premises_cidr             = "10.0.0.0/8"
  outpost_az                   = "eu-west-2a"
  environment                  = var.environment
  project                      = var.project
  interface_vpc_endpoint_cidrs = ["10.0.0.0/16", "192.168.100.0/24"]
}

# EKS Module
module "eks" {
  source = "git::https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/eks-cluster-automation?ref=master"

  tenant            = "example-tenant"
  service           = "example-service"
  environment       = var.environment
  deployment_type   = "workload"
  account           = "example-account"

  cluster = {
    version                 = "1.23"
    private_endpoint_access = true
    public_endpoint_access  = false
    create_role             = true
    create_kms              = true
    ami_type                = "AL2_x86_64"
    instance_type           = "m5.large"
    enabled_log_types       = ["api", "audit", "authenticator"]
  }

  node_group = {
    create_role    = true
    create_profile = true
    min_size       = 1
    max_size       = 3
    desired_size   = 2
  }

  node_managed_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  namespaces = ["kube-system", "argocd"]

  kms_key_administrators = ["arn:aws:iam::account-id:role/KMSAdmins"]

  ebs_devices = {
    xvda = {
      volume_size = 50
      volume_type = "gp2"
      encrypted   = true
      deletion    = true
    },
    xvdb = {
      volume_size = 100
      volume_type = "gp2"
      encrypted   = true
      deletion    = true
    }
  }
}


# ArgoCD Module
module "argocd" {
  source = "git::https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/helm-modules/argocd-helm-application?ref=master"

  name        = "argo-cd"
  namespace   = "argocd"
  chart       = "argo-cd"
  repository  = "https://argoproj.github.io/argo-helm"
  values      = file("${path.module}/30-argocd/values.yaml")

  depends_on  = [module.eks]
}