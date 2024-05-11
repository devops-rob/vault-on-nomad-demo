locals {
  environment_variables = { for k, v in var.environment_variables : k =>
    {
      value       = v
      category    = "env"
      description = lookup(var.variables_descriptions, k, null)
    }
  }

  aws_environment_sensitive_variables = { for k, v in var.aws_environment_sensitive_variables : k =>
    {
      value       = v
      category    = "env"
      description = lookup(var.variables_descriptions, k, null)
      sensitive   = true
    }
  }

  aws_variables = merge(
    local.environment_variables,
    local.aws_environment_sensitive_variables
  )
}



resource "tfe_organization" "this" {
  name  = var.tfc_org
  email = "admin@company.com"
}

data "tfe_workspace" "nomad-infrastructure" {
  name         = "1-nomad-infrastructure"
  organization = tfe_organization.this.id
}

data "tfe_workspace" "nomad-configuration" {
  name         = "2-nomad-configuration"
  organization = tfe_organization.this.id
}
data "tfe_workspace" "nomad-job-example-deployment" {
  name         = "3-nomad-job-example-deployment"
  organization = tfe_organization.this.id
}
resource "tfe_variable_set" "this" {
  name         = "AWS varset"
  description  = "AWS keys and secrets"
  organization = tfe_organization.this.name
}

resource "tfe_variable" "this" {
  for_each = local.aws_variables

  key             = each.key
  value           = each.value.value
  hcl             = try(each.value.hcl, null)
  category        = each.value.category
  description     = try(each.value.description, null)
  sensitive       = try(each.value.sensitive, false)
  variable_set_id = tfe_variable_set.this.id
}
