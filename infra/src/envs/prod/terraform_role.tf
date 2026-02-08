module "terraform_role" {
  source = "../../modules/iam_role"

  role_name               = local.terraform_role_name
  assume_role_policy_json = data.aws_iam_policy_document.terraform_assume_role_policy.json
}

data "aws_iam_policy_document" "terraform_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:user/career-roadmap-app-terraform",
      ]
    }
  }
}