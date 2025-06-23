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
  availability_zone = each.key
  tags = {
    Name = "public-${each.key}"
  }
}

resource "aws_subnet" "private_secure_devops_subnet" {
  for_each = var.private_subnets
  vpc_id     = aws_vpc.secure_devops_vpc.id
  cidr_block = cidrsubnet(aws_vpc.secure_devops_vpc.cidr_block, 8, each.value)
  availability_zone = each.key

  tags = {
    Name = "private-${each.key}"
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


resource "aws_eip" "secure_devops_eip" {
  depends_on = [aws_internet_gateway.secure_devops_gw] 
  domain   = "vpc"
}
 
resource "aws_nat_gateway" "secure_devops_nat" {
  allocation_id = aws_eip.secure_devops_eip.id
  subnet_id     = aws_subnet.public_secure_devops_subnet["us-east-1a"].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.secure_devops_gw]
}

resource "aws_route_table_association" "a" {
  depends_on = [ aws_subnet.public_secure_devops_subnet]
  for_each = aws_subnet.public_secure_devops_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.secure_devops_public_route_table.id
}

resource "aws_route_table_association" "b" {
  for_each = aws_subnet.private_secure_devops_subnet
  depends_on = [ aws_subnet.private_secure_devops_subnet]
  subnet_id     = each.value.id
  route_table_id = aws_route_table.secure_devops_private_route_table.id
}