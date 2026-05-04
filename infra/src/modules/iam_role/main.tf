resource "aws_iam_role" "main" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy_json
}

resource "aws_iam_role_policy" "main" {
  for_each = var.policies

  name   = each.key
  role   = aws_iam_role.main.id
  policy = each.value
}
