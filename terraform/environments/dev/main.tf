module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  environment     = var.environment
  private_subnets = var.private_subnets
  region          = var.region
}

module "alb" {
  source               = "../../modules/alb"
  public_subnets_ids   = module.vpc.public_subnets_ids
  environment         = var.environment
  vpc_id               = module.vpc.vpc_id
  container_port      = var.container_port
  listener_http_port  = var.listener_http_port
}

module "ecs" {
  source = "../../modules/ecs"
  environment = var.environment
  container_name = var.container_name
  container_image = var.container_image
  ecs_cpu = var.ecs_cpu
  ecs_memory = var.ecs_memory
  container_port = var.container_port
  tasks_count = var.tasks_count
  execution_role_arn = module.iam.iam_task_role_arn
  private_subnets_ids = module.vpc.private_subnets_ids
  vpc_id = module.vpc.vpc_id
  alb_sg_id = module.alb.alb_sg
  alb_tg_arn = module.alb.alb_tg_arn
}

module "iam" {
  source = "../../modules/iam"
  environment = var.environment
  ecs_task_execution_policy_arn = var.ecs_task_execution_policy_arn
}