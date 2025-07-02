resource "aws_iam_role" "secure_devops_eks_cluster_role" {
  name = "secure_devops_eks_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name        = "secure_devops_eks_cluster_role"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


resource "aws_iam_role_policy_attachment" "secure_devops_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.secure_devops_eks_cluster_role.name
}


resource "aws_iam_role" "secure_devops_node_group_role" {
  name = "secure_devops_node_group"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name        = "secure_devops_node_group_role"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "secure_nodes_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.secure_devops_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "secure_nodes_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.secure_devops_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "secure_nodes_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.secure_devops_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "secure_nodes_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.secure_devops_node_group_role.name
}


data "aws_iam_policy_document" "alb_controller_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "ServiceAccount"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "secure_devops_alb_controller_role" {
  name               = "secure_devops_eks_cluster_role"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_trust.json
  tags = {
    Name        = "secure_devops_eks_cluster_role"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "secure_devops_alb_controller_policy" {
  name   = "secure_devops_eks_cluster_role"
  policy = file("${path.module}/policy/aws-alb-policy.json")

}

resource "aws_iam_role_policy_attachment" "secure_devops_eks_alb_attachment" {
  policy_arn = aws_iam_policy.secure_devops_alb_controller_policy.arn
  role       = aws_iam_role.secure_devops_alb_controller_role.arn
}



