module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  environment     = var.environment
  private_subnets = var.private_subnets
  region          = var.region
}
