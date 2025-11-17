locals {
  name     = "debian-eks"
  vpc_cidr = "10.200.0.0/16"
  azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

  public_subnets  = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
  private_subnets = ["10.200.4.0/24", "10.200.5.0/24", "10.200.6.0/24"]

  tags = {
    Example = local.name
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

