provider "aws" {
  
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.100.0"
    }
  }
}
#You need to upgrade the terraform when you are changing the version of providers   --> terraform init -upgrade