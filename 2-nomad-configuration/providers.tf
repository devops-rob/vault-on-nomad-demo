terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.1.1"
    }

    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.2.1"
    }
  }
}

data "terraform_remote_state" "tfc" {
  backend = "remote"
  config = {
    organization = "TFC-ORG"

    workspaces = {
      name = "1-nomad-infrastructure"
    }
  }
}

provider "nomad" {
  address   = "http://${data.terraform_remote_state.tfc.outputs.nomad_server_public_ip}:4646"
  secret_id = data.terraform_remote_state.tfc.outputs.terraform_management_token
}

provider "terracurl" {}
