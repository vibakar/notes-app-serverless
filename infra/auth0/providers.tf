terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
    auth0 = {
      source  = "auth0/auth0"
      version = "1.32.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "auth0" {}