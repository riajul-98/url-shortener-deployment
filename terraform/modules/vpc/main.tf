resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr_block
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
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.project_vpc.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-public-${each.key}"
      Environment = var.environment
    }
  )
}

resource "aws_subnet" "project_private_subnet" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.project_vpc.id
  availability_zone = each.key
  cidr_block        = each.value
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-private-${each.key}"
      Environment = var.environment
    }
  )
}

resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-igw"
      Environment = var.environment
    }
  )
}

resource "aws_route_table" "project_public_rt" {
  vpc_id = aws_vpc.project_vpc.id
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-public-rt"
      Environment = var.environment
    }
  )
}

resource "aws_route" "project_public_rt_route" {
  route_table_id         = aws_route_table.project_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_igw.id
}

resource "aws_route_table_association" "project_public_rt_assoc" {
  for_each       = aws_subnet.project_public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.project_public_rt.id
}


resource "aws_route_table" "project_private_rt" {
  vpc_id = aws_vpc.project_vpc.id
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-private-rt"
      Environment = var.environment
    }
  )
}

resource "aws_route_table_association" "project_private_rt_assoc" {
  for_each       = aws_subnet.project_private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.project_private_rt.id
}


resource "aws_vpc_endpoint" "project_ecr_api_endpoint" {
  vpc_id              = aws_vpc.project_vpc.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.project_private_subnet)[*].id
  security_group_ids  = [aws_security_group.project_vpc_endpoint_sg.id]
  private_dns_enabled = true
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-ecr-api-endpoint"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_endpoint" "project_ecr_docker_endpoint" {
  vpc_id              = aws_vpc.project_vpc.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.project_private_subnet)[*].id
  security_group_ids  = [aws_security_group.project_vpc_endpoint_sg.id]
  private_dns_enabled = true
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-ecr-docker-endpoint"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_endpoint" "project_s3_endpoint" {
  vpc_id            = aws_vpc.project_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.project_private_rt.id]
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-s3-endpoint"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_endpoint" "project_dynamodb_endpoint" {
  vpc_id            = aws_vpc.project_vpc.id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.project_private_rt.id]
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-dynamodb-endpoint"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_endpoint" "project_cloudwatch_logs_endpoint" {
  vpc_id              = aws_vpc.project_vpc.id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.project_private_subnet)[*].id
  security_group_ids  = [aws_security_group.project_vpc_endpoint_sg.id]
  private_dns_enabled = true
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-cloudwatch-logs-endpoint"
      Environment = var.environment
    }
  )

}

resource "aws_security_group" "project_vpc_endpoint_sg" {
  name        = "${var.environment}-vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.project_vpc.id
  tags = merge(
    local.tags,
    {
      Name        = "${var.environment}-vpc-endpoint-sg"
      Environment = var.environment
    }
  )

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.project_vpc.cidr_block]
    description = "Allow HTTPS traffic from within the VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}