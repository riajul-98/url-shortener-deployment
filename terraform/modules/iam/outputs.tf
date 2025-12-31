output "iam_task_role_arn" {
    value       = aws_iam_role.ecs_task_execution_role.arn
    description = "The ARN of the IAM role for ECS task execution"
}