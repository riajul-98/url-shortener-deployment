variable "ecs_task_execution_policy_arn" {
  type        = string
  description = "ARN of the IAM policy to attach to the ECS task execution role"
}

variable "environment" {
  type = string
}