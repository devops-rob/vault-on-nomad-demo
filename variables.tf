variable "tfc_org" {
  default = "my-org"
}
variable "variables_descriptions" {
  description = "(Optional) A description for the variable set"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = <<EOF
(Optional) Map of sensitive variables of 'Terraform' category used in the variable set

Item syntax:
{
  TF_VAR_aws_default_region = value0,
	AWS_DEFAULT_REGION = value1,
  ssh_key = value2
  ...
}
EOF

  type    = map(any)
  default = {}
}
variable "aws_environment_sensitive_variables" {
  description = <<EOF
(Optional) Map of sensitive variables of 'Terraform' category used in the variable set

Item syntax:
{
  AWS_ACCESS_KEY_ID = value1,
  AWS_SECRET_ACCESS_KEY = value2
  ...
}
EOF

  type    = map(any)
  default = {}
}
