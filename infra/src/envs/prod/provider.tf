provider "aws" {
  region = var.aws_region[0]
  assume_role {
    role_arn = var.terraform_assume_role_arn
  }
  default_tags {
    tags = {
      Environment = var.env
      name        = var.project_name
    }
  }
}