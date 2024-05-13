terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }

    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.2.0"
    }

    nomad = {
      source  = "hashicorp/nomad"
      version = "2.1.1"
    }
  }
}

provider "aws" {
  # AWS credentials set up using environment variables
  #region = "eu-west-1"
}

provider "terracurl" {}

provider "nomad" {
  address   = "http://${aws_eip.nomad_server.public_ip}:4646"
  secret_id = jsondecode(terracurl_request.bootstrap_acl.response).SecretID
}
