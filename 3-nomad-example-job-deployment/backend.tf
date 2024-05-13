terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "iam-devopsrob"

    workspaces {
      name = "3-nomad-job-example-deployment"
    }
  }
}
