# AWS Staging VPC Terraform Module

## Overview
This Terraform module creates a production-ready VPC for staging environments with:
- 172.16.0.0/16 CIDR block
- 2 Availability Zones
- 2 Public subnets (one per AZ)
- 2 Private subnets (one per AZ)
- NAT Gateways for private subnet internet access
- Internet Gateway for public subnets
- VPC Endpoints for SSM and S3


## Module Usage
```hcl
module "vpc" {
  source = "../../modules/vpc"
  
  vpc_name             = "staging-vpc"
  vpc_cidr             = "172.16.0.0/16"
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
  public_subnet_cidrs  = ["172.16.0.0/24", "172.16.1.0/24"]
  private_subnet_cidrs = ["172.16.10.0/24", "172.16.11.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = false
  
  tags = {
    Environment = "staging"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_name | Name of the VPC | `string` | n/a | yes |
| vpc_cidr | CIDR block for VPC | `string` | `"172.16.0.0/16"` | no |
| availability_zones | List of AZs | `list(string)` | n/a | yes |
| public_subnet_cidrs | Public subnet CIDRs | `list(string)` | n/a | yes |
| private_subnet_cidrs | Private subnet CIDRs | `list(string)` | n/a | yes |
| enable_nat_gateway | Enable NAT Gateway | `bool` | `true` | no |
| single_nat_gateway | Use single NAT Gateway | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| public_subnet_ids | Public subnet IDs |
| private_subnet_ids | Private subnet IDs |
| nat_gateway_ids | NAT Gateway IDs |
| ssm_vpc_endpoint_id | SSM VPC Endpoint ID |
| s3_vpc_endpoint_id | S3 VPC Endpoint ID |

## Deployment

### With Terraform
```bash
terraform init
terraform validate
terraform plan
terraform apply
```
