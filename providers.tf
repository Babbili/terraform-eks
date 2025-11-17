terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.15"
    }
  }
}

provider "aws" {
  profile = "babbili-tf"
  region  = "us-east-1"
}

