terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25.2"
    }
  }
  backend "s3" {
    bucket         = "secure-devops-terraform-state"
    key            = "secure-devops/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "secure-devops-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.REGION
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.secure_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.secure_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "secure_cluster" {
  name = aws_eks_cluster.secure_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.secure_cluster.name
}