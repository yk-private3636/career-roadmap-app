module "terraform_role" {
  source = "../../modules/iam_role"

  role_name               = local.terraform_role_name
  assume_role_policy_json = data.aws_iam_policy_document.terraform_assume_role_policy.json
}

data "aws_iam_policy_document" "terraform_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:user/career-roadmap-app-terraform",
        "arn:aws:sts::${var.account_id}:assumed-role/${local.terraform_role_name}/GitHubActions"
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