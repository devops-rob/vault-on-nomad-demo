#!/usr/bin/env bash

mkdir "1-nomad-infrastructure" \
  "2-nomad-configuration" \
  "3-nomad-example-job-deployment"

echo '
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "TFC Org"

    workspaces {
      name = "1-nomad-infrastructure"
    }
  }
}
' > 1-nomad-infrastructure/backend.tf

echo '
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "TFC Org"

    workspaces {
      name = "2-nomad-configuration"
    }
  }
}
' > 2-nomad-configuration/backend.tf

echo '
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "TFC Org"

    workspaces {
      name = "3-nomad-example-job-deployment"
    }
  }
}
' > 3-nomad-example-job-deployment/backend.tf

terraform -chdir=1-nomad-infrastructure init && \
  terraform -chdir=2-nomad-configuration init && \
  terraform -chdir=3-nomad-example-job-deployment init