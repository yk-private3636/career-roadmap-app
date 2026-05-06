module "terraform_role" {
  source = "../../modules/iam_role"

  role_name               = local.terraform_role_name
  assume_role_policy_json = data.aws_iam_policy_document.terraform_assume_role_policy.json

  policies = {
    (local.terraform_role_policy_name) = data.aws_iam_policy_document.terraform_role_policy.json
  }
}

data "aws_iam_policy_document" "terraform_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:user/career-roadmap-app-terraform",
      ]
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:sts::${var.account_id}:assumed-role/${local.terraform_role_name}/GitHubActions"
      ]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:yk-private3636/career-roadmap-app:*"]
    }
  }
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
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
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
      "iam:CreateServiceLinkedRole",
      "iam:RemoveRoleFromInstanceProfile",
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
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
      "ec2:DescribeRouteTables",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:DescribeInternetGateways",
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway",
      "ec2:DescribeNatGateways",
      "ec2:AllocateAddress",
      "ec2:ReleaseAddress",
      "ec2:DescribeAddresses",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:DescribeSecurityGroupRules",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:TagResource",
      "ecr:ListTagsForResource",
      "ecr:DescribeRepositories",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:DeleteRepository",
      "ecr:DeleteLifecyclePolicy",
      "ecr:PutLifecyclePolicy",
      "ecr:PutImageTagMutability",
      "ecr:UntagResource",
      "ecr:GetLifecyclePolicy",
    ]
    resources = [
      "arn:aws:ecr:${var.aws_region[0]}:${var.account_id}:repository/${local.ecr_repository_name}",
      "arn:aws:ecr:${var.aws_region[0]}:${var.account_id}:repository/${local.ecr_repository_name}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:CreateCluster",
      "eks:DeleteCluster",
      "eks:UpdateClusterVersion",
      "eks:UpdateClusterConfig",
      "eks:DescribeUpdate",
    ]
    resources = [
      "arn:aws:eks:${var.aws_region[0]}:${var.account_id}:cluster/${local.eks_cluster_name}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:DeleteAccessEntry",
    ]
    resources = [
      "arn:aws:eks:ap-northeast-1:${var.account_id}:access-entry/${local.name}-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:DescribeNodegroup",
      "eks:ListNodegroups",
      "eks:CreateNodegroup",
      "eks:DeleteNodegroup",
      "eks:DescribeAccessEntry",
      "eks:TagResource",
      "eks:UntagResource",
      "eks:CreateAccessEntry",
    ]
    resources = ["*"]
  }
}

