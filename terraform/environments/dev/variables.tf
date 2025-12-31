variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block"
}

variable "public_subnets" {
  type        = map(string)
  description = "Map of public subnet CIDR blocks"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "private_subnets" {
  type        = map(string)
  description = "Map of private subnet CIDR blocks"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "container_name" {
  type = string
  description = "Container name"
}

variable "container_image" {
  type = string
  description = "Container image"
}

variable "ecs_cpu" {
  type = number
  description = "Number of CPUs assigned to the ECS task"
}

variable "ecs_memory" {
  type = number
  description = "Amount of memory assigned to the ECS task"
}

variable "container_port" {
  type = number
  description = "Port on which the container listens"
}

variable "ecs_task_execution_policy_arn" {
  type        = string
  description = "ARN of the IAM policy to attach to the ECS task execution role"
}

variable "tasks_count" {
  type = number
  description = "Number of tasks to run"
}

variable "execution_role_arn" {
  type = string
  description = "IAM role name for ECS task execution"
}

variable "alb_sg_id" {
  type = string
  description = "Security group ID of the ALB"
  
}

variable "listener_http_port" {
  type        = number
  description = "The port on which the ALB listens for HTTP traffic"
  
}