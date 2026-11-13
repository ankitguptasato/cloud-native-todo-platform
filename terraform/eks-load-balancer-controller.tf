
# AWS Load Balancer Controller IAM Policy

resource "aws_iam_policy" "load_balancer_controller" {
  name        = "platform-lab-aws-load-balancer-controller-policy"
  description = "IAM permissions for the AWS Load Balancer Controller"

  policy = file("${path.module}/aws-lbc-iam-policy.json")
}


# IAM Role for AWS Load Balancer Controller

resource "aws_iam_role" "load_balancer_controller" {
  name = "platform-lab-aws-load-balancer-controller-role"

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

          "${local.eks_oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}


# Attach AWS permissions to the controller role

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = aws_iam_role.load_balancer_controller.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}
