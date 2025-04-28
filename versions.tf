terraform {
  required_providers {
    cato = {
      # source = "catonetworks/cato"
      source  = "terraform-providers/cato"
      version = "0.0.23"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.3.0"
}