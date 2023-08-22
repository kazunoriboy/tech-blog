# --------------------
# terraform settings
# --------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12"
    }
  }

  required_version = ">= 1.5.0"
}

# --------------------
# provider settings
# --------------------
# AWS
provider "aws" {
  profile = "private"
  region  = "ap-northeast-1"
}

# to get my public ip address
provider "http" {}

