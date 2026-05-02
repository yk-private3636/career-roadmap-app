variable "repository_name" {
    type = string
}

variable "force_delete" {
    type    = bool
    default = false
}

variable "lifecycle_policy_json" {
    type = string
}