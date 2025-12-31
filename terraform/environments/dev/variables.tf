variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block"
}

variable "public_subnets" {
    type        = map(string)
    description = "Map of public subnet CIDR blocks"
}

variable "environment" {
    type = string
    description = "Environment name"
    default = "dev"
}