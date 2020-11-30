provider "aws" {
  access_key = var.acess_key
  secret_key = var.secret_key
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "intercorp-terraform-tfstate"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}
