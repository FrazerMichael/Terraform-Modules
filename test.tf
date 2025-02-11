terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  for_each = var.sg_service

  name = each.value.name
  description = each.value.description
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      description = "SSH access for SSM"
      cidr_blocks = "100.207.100.68/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      description = "SSH access for SSM"
      cidr_blocks = "100.207.109.70/32"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      description = "SSH access for SSM"
      cidr_blocks = "100.207.109.70/32"
    }
  ]
}


variable "sg_service" {
  type = map(object({
    name              = string
    health_check_path = string
  }))
  default = {
    test1 = {
        "name" = "test1"
        "default" = "This is test1"
    }
    test2 = {
        "name" = "test2"
        "default" = "This is test2"
    }
    test3 = {
        "name" = "test2"
        "default" = "This is test2"
    }
  }
}
