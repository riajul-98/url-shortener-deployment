resource "aws_iam_role" "project_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  tags = merge(
      local.tags,
      {
      Name        = "ecsTaskExecutionRole"
      Environment = var.environment
      }
  )
}

# Attaching policy to IAM role
resource "aws_iam_role_policy_attachment" "project_ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.ecs_task_execution_policy_arn
}
