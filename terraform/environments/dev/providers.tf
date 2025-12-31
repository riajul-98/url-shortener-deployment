terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }

  backend "s3" {
    bucket       = "url-shortener-riajul"
    region       = "eu-west-2"
    key          = "dev/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}



provider "aws" {
  region = "eu-west-2"
}

