variable "REGION" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"

}

variable "public_subnets" {
  description = "Map of public subnets"
  type        = map(number)
  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
  }
}

variable "private_subnets" {
  description = "Map of public subnets"
  type        = map(number)
  default = {
    "us-east-1a" = 3
    "us-east-1b" = 4
  }
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the EKS public endpoint"
}

variable "github_actions_role_arn" {
  type        = string
  description = "ARN of the GitHub Actions IAM Role"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair to use for EKS node access"
  type        = string
}

variable "enable_k8s_resources" {
  description = "Enable Kubernetes resources"
  type        = bool
  default     = false
}

variable "enable_k8s_import" {
  description = "Temporarily enable aws-auth resource for import in CI"
  type        = bool
  default     = false
}