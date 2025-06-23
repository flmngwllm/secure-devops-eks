variable "REGION" {
    description = "AWS region to deploy resources"
    default = "us-east-1"

}

variable "public_subnets" {
    description = "Map of public subnets"
    default = {
        "public_subnet_1" = 1
        "public_subnet_2" = 2
    }
}

variable "private_subnets" {
    description = "Map of public subnets"
    default = {
        "private_subnet_1" = 1
        "private_subnet_2" = 2
    }
}