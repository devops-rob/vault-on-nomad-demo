# Vault on Nomad Demo

## Usage

``` shell

# login to tfc to provide valid credentials for ~/.terraform.d/credentials.tfrc.json
terraform login

# set your tfc org of choice as a env var ( this will be useful later)
export TF_VAR_tfc_org="<your_TF_VAR_tfc_org>"

# export the ssh_key TF_VAR to populate your key this expects default ssh usage
export TF_VAR_ssh_key="/Users/$(whoami)/.ssh/id_rsa.pub"

# run the set up script which will initiate and create the workspaces using the Terraform client
# utilises the $TF_VAR_tfc_org env var
bash ./tfc-setup.sh

```

Decide if you want to run remote or local? with TFC/TFE if you choose local you will need to update the workspaces "execution mode "in the settings it defaults to `remote`.

* <https://app.terraform.io/app/$TF_VAR_tfc_org/workspaces/1-nomad-configuration/settings/general>
* <https://app.terraform.io/app/$TF_VAR_tfc_org/workspaces/2-nomad-configuration/settings/general>
* <https://app.terraform.io/app/$TF_VAR_tfc_org/workspaces/3-nomad-example-job-deployment/settings/general>


### Variables and varset code

If you want to continue with `remote` you will need to add your SSH key and AWS credentials to TFC take a look at this tutorial <https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-multiple-variable-sets>

You will find a helper in this folder in the form of some simple code based on the `TFE` provider to create a varset and assign it to the workspaces. First create the workspaces as the material preceding this.

Then review the terraform manifests and `*.tfvars.example` presented below.

``` shell

├── tfc_variable_set.tf
├── this.auto.tfvars.example
├── variables.tf
└── providers.tf

```

The code provided is intended to also make use of `TF_VAR_tfc_org` exported environment variable. The code will create a variable set and assign it to the workspaces required for this demo.

Due to the expectation this code is run from your local client, we are not worried about secrets in state, but you should take care not to commit your AWS secrets to version control.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/organization) | resource |
| [tfe_variable.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) | resource |
| [tfe_workspace.nomad-configuration](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |
| [tfe_workspace.nomad-infrastructure](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |
| [tfe_workspace.nomad-job-example-deployment](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment_sensitive_variables"></a> [aws\_environment\_sensitive\_variables](#input\_aws\_environment\_sensitive\_variables) | (Optional) Map of sensitive variables of 'Terraform' category used in the variable set<br><br>Item syntax:<br>{<br>  AWS\_ACCESS\_KEY\_ID = value1,<br>  AWS\_SECRET\_ACCESS\_KEY = value2<br>  ...<br>} | `map(any)` | `{}` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | (Optional) Map of sensitive variables of 'Terraform' category used in the variable set<br><br>Item syntax:<br>{<br>  TF\_VAR\_aws\_default\_region = value0,<br>	AWS\_DEFAULT\_REGION = value1,<br>  ssh\_key = value2<br>  ...<br>} | `map(any)` | `{}` | no |
| <a name="input_tfc_org"></a> [tfc\_org](#input\_tfc\_org) | n/a | `string` | `"my-org"` | no |
| <a name="input_variables_descriptions"></a> [variables\_descriptions](#input\_variables\_descriptions) | (Optional) A description for the variable set | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
