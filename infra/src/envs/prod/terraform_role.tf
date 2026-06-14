import {
  to = module.terraform_role.aws_iam_role.main
  identity = {
    "name" = local.terraform_role_name
  }
}

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
      "iam:Get*",
      "iam:List*",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:CreateRole",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${local.name}-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:UpdateRole",
      "iam:PutRolePolicy",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${local.name}-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:TagRole",
      "iam:UntagRole",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${local.name}-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:CreateOpenIDConnectProvider",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:DeleteOpenIDConnectProvider",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:ResourceTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
      "iam:CreateServiceLinkedRole",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNatGateways",
      "ec2:DescribeAddresses",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSecurityGroupRules",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateVpc",
      "ec2:CreateSubnet",
      "ec2:CreateRouteTable",
      "ec2:CreateInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:AllocateAddress",
      "ec2:CreateSecurityGroup",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteVpc",
      "ec2:ModifyVpcAttribute",
      "ec2:DeleteSubnet",
      "ec2:DeleteRouteTable",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:ReplaceRoute",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:DeleteNatGateway",
      "ec2:ReleaseAddress",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:ModifySecurityGroupRules",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:DescribeRepositories",
      "ecr:ListTagsForResource",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:TagResource",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
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
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:DescribeNodegroup",
      "eks:ListNodegroups",
      "eks:DescribeAccessEntry",
      "eks:DescribeUpdate",
      "eks:ListAssociatedAccessPolicies",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:CreateCluster",
    ]
    resources = [
      "arn:aws:eks:${var.aws_region[0]}:${var.account_id}:cluster/${local.eks_cluster_name}"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:DeleteCluster",
      "eks:UpdateClusterVersion",
      "eks:UpdateClusterConfig",
      "eks:AssociateEncryptionConfig",
    ]
    resources = [
      "arn:aws:eks:${var.aws_region[0]}:${var.account_id}:cluster/${local.eks_cluster_name}"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:CreateNodegroup",
      "eks:CreateAccessEntry",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:DeleteNodegroup",
      "eks:AssociateAccessPolicy",
      "eks:DisassociateAccessPolicy",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [var.project_name]
    }
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
      "eks:TagResource",
      "eks:UntagResource",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:ListResourceTags",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:CreateKey",
      "kms:TagResource",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"
      values   = [var.project_name]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:ScheduleKeyDeletion",
      "kms:PutKeyPolicy",
      "kms:CreateGrant",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [var.project_name]
    }
  }
}

