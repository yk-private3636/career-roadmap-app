variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "default_route" {
    description = "Default route (0.0.0.0/0) target. Specify exactly one of gateway_id (IGW) or nat_gateway_id (NAT GW)."
    type = object({
        gateway_id     = optional(string)
        nat_gateway_id = optional(string)
    })
}
