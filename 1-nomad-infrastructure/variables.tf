variable "ssh_key" {
  default = "/Users/$(whoami)/.ssh/id_rsa.pub"
}
variable "aws_default_region" {
  type        = string
  description = "(optional) variable for aws region"
}
