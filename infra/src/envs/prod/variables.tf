variable "env" {
  type = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.env)
    error_message = "env must be one of: dev, stg, prod."
  }
}

variable "project_name" {
  type    = string
  default = "career-roadmap-app"

  validation {
    condition     = var.project_name == "career-roadmap-app"
    error_message = "The project_name variable must be set to 'career-roadmap-app'. Overriding this value is not allowed."
  }
}

variable "aws_region" {
  type    = list(string)
  default = ["ap-northeast-1", "ap-northeast-3"]
}

variable "aws_az" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}

variable "account_id" {
  type      = string
  sensitive = true
}

variable "terraform_assume_role_arn" {
  type      = string
  sensitive = true
}