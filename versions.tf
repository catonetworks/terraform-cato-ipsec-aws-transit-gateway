terraform {
  required_providers {
    cato = {
      source = "catonetworks/cato"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.3.0"
}