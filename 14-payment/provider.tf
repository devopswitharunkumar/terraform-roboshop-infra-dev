terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "roboshop-infra-remotestate-dev"
    key            = "payment"
    region         = "us-east-1"
    dynamodb_table = "roboshop-infra-remotelock-dev"
  }
}

provider "aws" {
  region = "us-east-1"
}