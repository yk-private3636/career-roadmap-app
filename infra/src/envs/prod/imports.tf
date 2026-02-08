import {
  to = module.terraform_role.aws_iam_role.main
  identity = {
    "name" = local.terraform_role_name
  }
}