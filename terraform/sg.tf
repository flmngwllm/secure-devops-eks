resource "aws_security_group" "secure_devops_eks_nodes_sg" {
  name        = "eks_nodes_sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.secure_devops_vpc.id

  ingress {
    description = "Allow all node-to-node"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks_nodes_sg"
  }
}