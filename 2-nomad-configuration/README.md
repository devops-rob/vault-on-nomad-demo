<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nomad"></a> [nomad](#requirement\_nomad) | 2.1.1 |
| <a name="requirement_nomad"></a> [nomad](#requirement\_nomad) | 2.1.1 |
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | 1.2.1 |
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | 1.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nomad"></a> [nomad](#provider\_nomad) | 2.1.1 |
| <a name="provider_terracurl"></a> [terracurl](#provider\_terracurl) | 1.2.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [nomad_job.vault](https://registry.terraform.io/providers/hashicorp/nomad/2.1.1/docs/resources/job) | resource |
| [nomad_job.vault-unsealer](https://registry.terraform.io/providers/hashicorp/nomad/2.1.1/docs/resources/job) | resource |
| [nomad_namespace.vault](https://registry.terraform.io/providers/hashicorp/nomad/2.1.1/docs/resources/namespace) | resource |
| [nomad_variable.unseal](https://registry.terraform.io/providers/hashicorp/nomad/2.1.1/docs/resources/variable) | resource |
| [terracurl_request.configure_jwt](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/resources/request) | resource |
| [terracurl_request.enable_jwt](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/resources/request) | resource |
| [terracurl_request.init](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/resources/request) | resource |
| [terraform_remote_state.tfc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_init"></a> [init](#output\_init) | n/a |
<!-- END_TF_DOCS -->