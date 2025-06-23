
data "aws_availability_zones" "available" {}

resource "aws_vpc" "secure_devops_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Secure-devops-VPC"
  }
}

resource "aws_subnet" "public_secure_devops_subnet" {
  for_each = var.public_subnets
  vpc_id     = aws_vpc.secure_devops_vpc.id
  cidr_block = cidrsubnet(aws_vpc.secure_devops_vpc.cidr_block, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name = "secure_devops_subnet"
  }
}

resource "aws_subnet" "private_secure_devops_subnet" {
  for_each = var.private_subnets
  vpc_id     = aws_vpc.secure_devops_vpc.id
  cidr_block = cidrsubnet(aws_vpc.secure_devops_vpc.cidr_block, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name = "secure_devops_subnet"
  }
}

resource "aws_internet_gateway" "secure_devops_gw" {
  vpc_id = aws_vpc.secure_devops_vpc.id

  tags = {
    Name = "secure_devops_gw"
  }
}

resource "aws_route_table" "secure_devops_public_route_table" {
  vpc_id = aws_vpc.secure_devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secure_devops_gw.id
  }
  
  tags = {
    Name = "secure_devops_route_table"
  }
}


resource "aws_route_table" "secure_devops_private_route_table" {
  vpc_id = aws_vpc.secure_devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.secure_devops_nat.id
  }
  
  tags = {
    Name = "secure_devops_route_table"
  }
}



# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.public_secure_devops_subnet.id
#   route_table_id = aws_route_table.secure_devops_route_table.id
# }

# resource "aws_route_table_association" "b" {
#   gateway_id     = aws_internet_gateway.secure_devops_gw.id
#   route_table_id = aws_route_table.secure_devops_route_table.id
# }