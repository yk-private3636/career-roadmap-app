module "terraform_role_policy" {
  source = "../../modules/iam_role_policy"

  policy_name = local.terraform_role_policy_name
  role_id     = module.terraform_role.id
  policy_json = data.aws_iam_policy_document.terraform_role_policy.json
}

data "aws_iam_policy_document" "terraform_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::career-roadmap-app-tfstate",
      "arn:aws:s3:::career-roadmap-app-tfstate/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:UpdateRole",
      "iam:PutRolePolicy",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:UntagRole",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${local.name}-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:Get*",
      "iam:List*",
      "iam:CreateRole",
      "iam:TagRole",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider",
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:PassRole",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateVpc",
      "ec2:DeleteVpc",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:CreateSubnet",
      "ec2:DeleteSubnet",
      "ec2:DescribeSubnets",
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:AssociateRouteTable",
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]
    resources = [
      "*"
    ]
  }
}