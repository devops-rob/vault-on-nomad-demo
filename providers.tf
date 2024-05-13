terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
      #version = "~> 0.55"
    }
  }
}

provider "tfe" {
  # Configuration options
  organization = var.tfc_org
}
