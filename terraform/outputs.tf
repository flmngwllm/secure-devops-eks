output "cluster_name" {
  value = aws_eks_cluster.secure_cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.secure_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.secure_cluster.certificate_authority[0].data
}

output "node_group_name" {
  value = aws_eks_node_group.secure_devops_node_group.node_group_name
}

output "vpc_id" {
  value = aws_vpc.secure_devops_vpc.id
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.secure_app_repo.repository_url
  description = "URL of the ECR repository to push images"
}

output "gha_admin_policy_arn" {
  value = aws_eks_access_policy_association.gha_admin.policy_arn
}
