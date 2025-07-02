terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
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
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      aws_eks_cluster.secure_cluster.name,
      "--region",
      var.REGION
    ]
  }
}

data "aws_eks_cluster" "secure_cluster" {
  name = aws_eks_cluster.secure_cluster.name
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket = "secure-devops-terraform-state"
    key    = "bootstrap/terraform.tfstate"
    region = "us-east-1"
  }
}

# data "aws_eks_cluster_auth" "cluster" {
#   name = aws_eks_cluster.secure_cluster.name
# }