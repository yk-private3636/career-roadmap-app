resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.oidc_issuer
  client_id_list = [
    "sts.amazonaws.com",
  ]
}