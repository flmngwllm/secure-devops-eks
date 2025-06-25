resource "aws_eks_cluster" "secure_cluster" {
  name = "secure_cluster"

  access_config {
    authentication_mode = "API"

  }

  role_arn = aws_iam_role.secure_devops_eks_cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.public_secure_devops_subnet["us-east-1a"].id,
      aws_subnet.public_secure_devops_subnet["us-east-1b"].id,
      aws_subnet.private_secure_devops_subnet["us-east-1a"].id,
      aws_subnet.private_secure_devops_subnet["us-east-1b"].id,
    ]

    endpoint_public_access = true
    public_access_cidrs    = ["${var.allowed_ip}/32"]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.secure_devops_cluster_AmazonEKSClusterPolicy,
  ]

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


}



resource "aws_eks_node_group" "secure_devops_node_group" {
  cluster_name    = aws_eks_cluster.secure_cluster.name
  node_group_name = "secure_devops_node_group"
  node_role_arn   = aws_iam_role.secure_devops_node_group_role.arn
  subnet_ids = [aws_subnet.private_secure_devops_subnet["us-east-1a"].id,
  aws_subnet.private_secure_devops_subnet["us-east-1b"].id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.secure_nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.secure_nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.secure_nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}