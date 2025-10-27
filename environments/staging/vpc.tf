terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "modulevpc"
    key            = "staging/vpc/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    use_lockfile   = true
  }
}

provider "aws" {
  region = "eu-central-1"
  
  default_tags {
    tags = {
      Environment = "staging"
      ManagedBy   = "terraform"
    }
  }
}

module "staging_vpc" {
  source = "../../modules/vpc"
  
  vpc_name           = "staging-vpc"
  vpc_cidr           = "172.16.0.0/16"
  availability_zones = ["eu-central-1a", "eu-central-1b"]
  
  # Two public subnets (one per AZ)
  public_subnet_cidrs = [
    "172.16.0.0/24",   # eu-central-1a public
    "172.16.1.0/24"    # eu-central-1b public
  ]
  
  # Two private subnets (one per AZ)
  private_subnet_cidrs = [
    "172.16.10.0/24",  # eu-central-1a private
    "172.16.11.0/24"   # eu-central-1b private
  ]
  
  enable_nat_gateway = true
  single_nat_gateway = false  # One NAT Gateway per AZ for HA
  
  tags = {
    Project = "staging-infrastructure"
  }
}

# Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.staging_vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.staging_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.staging_vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.staging_vpc.nat_gateway_ids
}
