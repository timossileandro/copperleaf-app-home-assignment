provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.8.0"

  backend "s3" {
    bucket = "some-bucket-name"
    key    = "key/path/terraform.tfstate"
    region = "ap-southeast-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}