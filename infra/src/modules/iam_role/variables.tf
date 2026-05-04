variable "role_name" {
    type = string
}

variable "assume_role_policy_json" {
    type = string
}

variable "policies" {
    description = "Inline policies attached to the role. Keyed by policy name → policy JSON."
    type        = map(string)
    default     = {}
}
