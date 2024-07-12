terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }
  }
  required_version = "~>1.9.1"
}
provider "aws" {
  region = var.region
}
