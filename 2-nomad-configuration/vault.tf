resource "terracurl_request" "enable_jwt" {
  method = "POST"
  name   = "enable_jwt"
  response_codes = [
    200,
    201,
    204
  ]
  url = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/sys/auth/jwt"

  headers = {
    X-Vault-Token = jsondecode(terracurl_request.init.response).root_token
  }

  request_body = <<EOF
{
  "type": "jwt",
  "description": "JWT auth method for Nomad workload identities"
}
EOF

  destroy_url    = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/sys/auth/jwt"
  destroy_method = "DELETE"

  depends_on = [
    nomad_job.vault-unsealer
  ]

}

resource "terracurl_request" "configure_jwt" {
  method = "POST"
  name   = "configure_jwt"
  response_codes = [
    200,
    201,
    204
  ]
  url = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/auth/jwt/config"
  headers = {
    X-Vault-Token = jsondecode(terracurl_request.init.response).root_token
  }
  request_body = <<EOF
{
  "jwks_url": "http://${data.terraform_remote_state.tfc.outputs.nomad_server_public_ip}:4646/.well-known/jwks.json",
  "bound_issuer": "http://${data.terraform_remote_state.tfc.outputs.nomad_server_public_ip}:4646"
}

EOF

  destroy_method = "DELETE"
  destroy_response_codes = [
    200,
    201,
    204
  ]
  destroy_url = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/auth/jwt/role/"

  depends_on = [
    nomad_job.vault-unsealer,
    terracurl_request.enable_jwt
  ]
}