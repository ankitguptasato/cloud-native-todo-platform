
# EKS Cluster

resource "aws_eks_cluster" "platform" {
  name     = "platform-lab"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private.id,
      aws_subnet.private_secondary.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true

    public_access_cidrs = ["123.225.67.152/32"]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }



  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}


# EKS Managed Worker Node Group

resource "aws_eks_node_group" "platform" {
  cluster_name    = aws_eks_cluster.platform.name
  node_group_name = "platform-lab-workers"
  node_role_arn   = aws_iam_role.eks_node.arn

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private_secondary.id
  ]

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker,
    aws_iam_role_policy_attachment.eks_node_cni,
    aws_iam_role_policy_attachment.eks_node_ecr
  ]
}


# Outputs

output "eks_cluster_name" {
  value = aws_eks_cluster.platform.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.platform.endpoint
}

output "eks_node_group_name" {
  value = aws_eks_node_group.platform.node_group_name
}
