# nomad-infrastructure

Manage the resources to deploy a HashiCorp Nomad server and client infrastructure.
prepare the infrastructure for a Vault deployment.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.38.0 |
| <a name="requirement_nomad"></a> [nomad](#requirement\_nomad) | 2.1.1 |
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.38.0 |
| <a name="provider_nomad"></a> [nomad](#provider\_nomad) | 2.1.1 |
| <a name="provider_terracurl"></a> [terracurl](#provider\_terracurl) | 1.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eip.nomad_server](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/eip) | resource |
| [aws_eip_association.nomad_server](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/eip_association) | resource |
| [aws_instance.nomad_clients](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/instance) | resource |
| [aws_instance.nomad_clients_vault_backup](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/instance) | resource |
| [aws_instance.nomad_servers](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/instance) | resource |
| [aws_key_pair.deployer](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/key_pair) | resource |
| [aws_security_group.egress](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/security_group) | resource |
| [aws_security_group.nomad](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/security_group) | resource |
| [aws_security_group.ssh](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/security_group) | resource |
| [aws_security_group.vault](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/resources/security_group) | resource |
| [nomad_acl_policy.anonymous](https://registry.terraform.io/providers/hashicorp/nomad/2.1.1/docs/resources/acl_policy) | resource |
| [nomad_acl_token.terraform](https://registry.terraform.io/providers/hashicorp/nomad/2.1.1/docs/resources/acl_token) | resource |
| [terracurl_request.bootstrap_acl](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.0/docs/resources/request) | resource |
| [terracurl_request.nomad_status](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.0/docs/resources/request) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/5.38.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | n/a | `string` | `"/Users/$(whoami)/.ssh/id_rsa.pub"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nomad_clients_private_ips"></a> [nomad\_clients\_private\_ips](#output\_nomad\_clients\_private\_ips) | n/a |
| <a name="output_nomad_clients_public_ips"></a> [nomad\_clients\_public\_ips](#output\_nomad\_clients\_public\_ips) | n/a |
| <a name="output_nomad_server_private_ip"></a> [nomad\_server\_private\_ip](#output\_nomad\_server\_private\_ip) | n/a |
| <a name="output_nomad_server_public_ip"></a> [nomad\_server\_public\_ip](#output\_nomad\_server\_public\_ip) | n/a |
| <a name="output_nomad_ui"></a> [nomad\_ui](#output\_nomad\_ui) | n/a |
| <a name="output_terraform_management_token"></a> [terraform\_management\_token](#output\_terraform\_management\_token) | n/a |
<!-- END_TF_DOCS -->
