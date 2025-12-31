# Creating Security Group for ECS tasks
resource "aws_security_group" "project_ecs_sg" {
  name        = "project-ecs-sg"
  description = "Allow HTTP traffic from the load balancer"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = merge(
        local.tags,
        {
        Name        = "project-ecs-sg"
        Environment = var.environment
        }
    )
}

resource "aws_cloudwatch_log_group" "project_log_group" {
  name              = "${var.environment}/ecs/project-log-group"
  retention_in_days = 14

    tags = merge(
        local.tags,
        {
        Name        = "project-log-group"
        Environment = var.environment
        }
    )
}

resource "aws_ecs_cluster" "project_ecs_cluster" {
  name = "${var.environment}-project-ecs-cluster"
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.project_log_group.name
      }
    }
  }

  
    tags = merge(
        local.tags,
        {
        Name        = "${var.environment}-project-ecs-cluster"
        Environment = var.environment
        }
    )
}

resource "aws_ecs_task_definition" "project_task_definition" {
  family = "${var.environment}-project-task-definition"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = var.execution_role_arn
  network_mode = "awsvpc"
  cpu    = var.ecs_cpu
  memory  = var.ecs_memory
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      environment = [
        {
          name  = "TABLE_NAME"
          value = "var.ddb_table"      # Replace with actual table name variable when created
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.project_log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])
    tags = merge(
        local.tags,
        {
        Name        = "${var.environment}-project-task-definition"
        Environment = var.environment
        }
    )
}

resource "aws_ecs_service" "project_ecs_service" {
  name            = "${var.environment}-project-ecs-service"
  cluster         = aws_ecs_cluster.project_ecs_cluster.id
  task_definition = aws_ecs_task_definition.project_task_definition.arn
  desired_count   = var.tasks_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.private_subnets_ids
    assign_public_ip = false
    security_groups = [aws_security_group.project_ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

    tags = merge(
        local.tags,
        {
        Name        = "${var.environment}-project-ecs-service"
        Environment = var.environment
        }
    )
}

