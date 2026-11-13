
# Existing EKS OIDC provider
# Reuse the provider already registered in AWS IAM.

locals {
  eks_oidc_issuer = aws_eks_cluster.platform.identity[0].oidc[0].issuer

  eks_oidc_provider = replace(
    local.eks_oidc_issuer,
    "https://",
    ""
  )

  eks_oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.eks_oidc_provider}"
}


# IAM Role for EBS CSI Driver

resource "aws_iam_role" "ebs_csi" {
  name = "platform-lab-eks-ebs-csi-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = local.eks_oidc_provider_arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "${local.eks_oidc_provider}:aud" = "sts.amazonaws.com"

          "${local.eks_oidc_provider}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }]
  })
}


# Attach AWS EBS CSI Driver permissions

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role = aws_iam_role.ebs_csi.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


# Install EBS CSI Driver as an EKS managed add-on

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.platform.name

  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.67.2-eksbuild.1"

  service_account_role_arn = aws_iam_role.ebs_csi.arn

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi
  ]
}
