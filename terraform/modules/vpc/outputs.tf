output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.project_vpc.id
}

output "public_subnets_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.project_public_subnet : subnet.id]
  
}