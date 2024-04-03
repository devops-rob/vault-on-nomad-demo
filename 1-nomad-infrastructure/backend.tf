terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "iam-devopsrob"

    workspaces {
      name = "1-nomad-infrastructure"
    }
  }
}