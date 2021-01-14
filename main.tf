terraform {
  required_version = "~> 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "remote" {
    organization = "FlamaCorp"

    workspaces {
      name = "tf-aws-vpc"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "fj"
}

module "vpc" {
  source                         = "github.com/flamarion/terraform-aws-vpc?ref=v0.1.1"
  az                             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  cidr_block                     = "10.0.0.0/16"
  enable_dns_hostnames           = true
  enable_dns_support             = true
  public_subnets                 = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets                = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  database_subnets               = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  cache_subnets                  = ["10.0.31.0/24", "10.0.32.0/24", "10.0.42.0/24"]
  create_db_subnet_group         = true
  create_cache_subnet_group      = true
  db_subnet_group_name           = "db-subnet-group-${var.owner}"
  db_subnet_group_description    = "Database Subnet Group"
  cache_subnet_group_name        = "cache-subnet-group-${var.owner}"
  cache_subnet_group_description = "Cache Subnet Group"
  enable_nat_gateway             = true

  # Resource Tags
  vpc_tags = {
    "Name" = "vpc-${var.owner}"
  }
  public_subnet_tags = {
    "Name" = "public-subnet-${var.owner}"
  }
  private_subnet_tags = {
    "Name" = "private-subnet-${var.owner}"
  }
  database_subnet_tags = {
    "Name" = "database-subnet-${var.owner}"
  }
  db_subnet_group_tags = {
    "Name" = "db-subnet-group-${var.owner}"
  }
  cache_subnet_group_tags = {
    "Name" = "cache-subnet-group-${var.owner}"
  }
  nat_gw_tags = {
    "Name" = "nat-gw-${var.owner}"
  }
  eip_tags = {
    "Name" = "elastic-ip-${var.owner}"
  }
  igw_tags = {
    "Name" = "internet-gateway-${var.owner}"
  }
  public_rt_tags = {
    "Name" = "public-subnet-route-table-${var.owner}"
  }
  private_rt_tags = {
    "Name" = "private-subnet-route-table-${var.owner}"
  }
  db_rt_tags = {
    "Name" = "database-subnet-route-table-${var.owner}"
  }
  cache_rt_tags = {
    "Name" = "cache-subnet-route-table-${var.owner}"
  }
}

# Outputs
output "az" {
  value = module.vpc.az
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_subnets_id" {
  value = module.vpc.public_subnets_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets_id" {
  value = module.vpc.private_subnets_id
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "database_subnets_id" {
  value = module.vpc.database_subnets_id
}

output "database_subnet_group" {
  value = module.vpc.db_subnet_group
}

output "cache_subnets" {
  value = module.vpc.cache_subnets
}

output "cache_subnets_id" {
  value = module.vpc.cache_subnets_id
}

output "cache_subnet_group" {
  value = module.vpc.cache_subnet_group
}
