terraform {
  backend "s3" {
    bucket         = "terraform-state-dice-roller"
    key            = "dice-roller/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock-dice-roller"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }

  required_version = "1.11.3"
}

provider "aws" {
  region = "us-west-2"
}
