terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
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

