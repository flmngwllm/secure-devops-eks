resource "kubernetes_config_map" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  depends_on = [
    aws_eks_node_group.secure_devops_node_group
  ]
  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.secure_devops_node_group_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes"
        ]
      },
      {
        rolearn  = var.github_actions_role_arn
        username = "GitHubActions"
        groups   = ["system:masters"]
      }
    ])
  }

  #   lifecycle {
  #     prevent_destroy = true
  #     ignore_changes = [
  #       data["mapRoles"],
  #     ]
  #   }
}

