variable "cluster_name" {
    type = string
}

variable "cluster_iam_role_name" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "cluster_security_group_ids" {
    type    = list(string)
    default = []
}

variable "node_group_name" {
    type = string
}

variable "node_group_iam_role_name" {
    type = string
}

variable "node_group_instance_types" {
    type = list(string)
}

variable "node_group_disk_size" {
    type = number
}

variable "scaling" {
    type = object({
        min = number
        max = number
        desired = number
    })
}

variable "node_group_policies" {
    type = map(string)
}

variable "admin_principal_arn" {
    type = string
}

variable "ecr_arn" {
    type = string
}