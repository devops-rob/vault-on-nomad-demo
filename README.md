# Vault on Nomad Demo

## Usage

``` shell

# login to tfc to provide valid credentials for ~/.terraform.d/credentials.tfrc.json
terraform login

# set your tfc org of choice as a env var ( this will be useful later)
export TF_VAR_tfc_org="<your_TF_VAR_tfc_org>"

# export the ssh_key TF_VAR to populate your key this expects default ssh usage
export export TF_VAR_ssh_key="/Users/$(whoami)/.ssh/id_rsa.pub"

# run the set up script which will initiate and create the workspaces using the Terraform client
# utilises the $TF_VAR_tfc_org env var
bash ./tfc-setup.sh

```

Decide if you want to run remote or local? with TFC/TFE if you choose local you will need to update the workspaces "execution mode "in the settings it defaults to `remote`.

* <https://app.terraform.io/app/$TF_VAR_tfc_org/workspaces/1-nomad-configuration/settings/general>
* <https://app.terraform.io/app/$TF_VAR_tfc_org/workspaces/2-nomad-configuration/settings/general>
* <https://app.terraform.io/app/$TF_VAR_tfc_org/workspaces/3-nomad-example-job-deployment/settings/general>

If you want to continue with `remote` you will need to add your SSH key and AWS credentials to TFC take a look at this tutorial <https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-multiple-variable-sets>

