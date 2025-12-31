variable "environment" {
  description = "The environment name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  
}

variable "public_subnets_ids" {
    description = "List of public subnet IDs"
    type        = list(string)
}