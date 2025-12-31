variable "environment" {
  type = string
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

variable "tasks_count" {
  type = number
  description = "Number of tasks to run"
}

variable "private_subnets_ids" {
  type = list(string)
  description = "List of private subnet IDs for ECS tasks"
}

variable "execution_role_arn" {
    type = string
    description = "Task role ARN"
  
}

variable "vpc_id" {
  type = string
  description = "VPC ID where ECS tasks will be deployed"
}

variable "alb_sg_id" {
  type = string
  description = "Security Group ID of the ALB"
}

variable "alb_tg_arn" {
  type = string
  description = "ARN of the ALB target group"
}

variable "aws_region" {
  type = string
  description = "AWS Region"
}