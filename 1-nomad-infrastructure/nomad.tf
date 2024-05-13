resource "terracurl_request" "nomad_status" {
  method         = "GET"
  name           = "nomad_status"
  response_codes = [200]
  url            = "http://${aws_eip.nomad_server.public_ip}:4646/v1/status/leader"
  max_retry      = 4
  retry_interval = 10

  depends_on = [
    aws_instance.nomad_servers,
    aws_eip_association.nomad_server
  ]
}

resource "terracurl_request" "bootstrap_acl" {
  method         = "POST"
  name           = "bootstrap"
  response_codes = [200, 201]
  url            = "http://${aws_eip.nomad_server.public_ip}:4646/v1/acl/bootstrap"

  lifecycle {
    ignore_changes = all
  }

  depends_on = [
    terracurl_request.nomad_status,
    aws_eip_association.nomad_server
  ]
}

resource "nomad_acl_policy" "anonymous" {
  name      = "anonymous"
  rules_hcl = file("${path.cwd}/files/anonymous-policy.hcl")
}

resource "nomad_acl_token" "terraform" {
  type = "management"
  name = "terraform"
}
