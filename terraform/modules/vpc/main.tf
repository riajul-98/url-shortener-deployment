resource "aws_vpc" "project_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-vpc"
      Environment = var.environment
    }
  )
}


resource "aws_subnet" "project_public_subnet" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.project_vpc.id
  availability_zone = each.key
  cidr_block = each.value
}