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
}