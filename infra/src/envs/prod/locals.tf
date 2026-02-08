locals {
  name = "${var.env}-${var.project_name}"

  terraform_role_name        = "${local.name}-terraform-role"
  terraform_role_policy_name = "${local.name}-terraform-role-policy"
}