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

  destroy_headers = {
    X-Vault-Token = jsondecode(terracurl_request.init.response).root_token
  }

  destroy_response_codes = [
    "200",
    "201",
    "204",
  ]


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

  depends_on = [
    nomad_job.vault-unsealer,
    terracurl_request.enable_jwt
  ]
}

resource "terracurl_request" "snapshot_policy" {
  destroy_headers = {
    X-Vault-Token = jsondecode(terracurl_request.init.response).root_token
  }
  destroy_method = "DELETE"
  destroy_response_codes = [
    200,
    201,
    204,
  ]
  destroy_retry_interval = 10
  destroy_timeout        = 10
  destroy_url            = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/sys/policy/snapshot_policy"

  url  = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/sys/policy/snapshot_policy"
  name = "snapshot_policy"

  headers = {
    X-Vault-Token = jsondecode(terracurl_request.init.response).root_token
  }

  method       = "POST"
  request_body = <<EOF
{
  "policy": "path \"sys/storage/raft/snapshot\" {capabilities = [\"read\"]}"
}
EOF
  response_codes = [
    201,
    204,
  ]
  retry_interval = 10
  timeout        = 10
}

resource "terracurl_request" "snapshot_role" {
  method = "POST"
  name   = "snapshot_role"

  response_codes = [
    204
  ]

  url = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/auth/jwt/role/snapshot"

  headers = {
    X-Vault-Token = jsondecode(terracurl_request.init.response).root_token
  }

  request_body = <<EOF
{
  "bound_audiences": "nomadproject.io",
  "bound_claims": {
    "nomad_job_id": "vault-backup",
    "nomad_namespace": "vault-cluster",
    "nomad_task": "vault-backup"
    },
  "role_type": "jwt",
  "token_policies": "snapshot_policy",
  "user_claim": "sub"
}
EOF

  destroy_url    = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/auth/jwt/role/snapshot"
  destroy_method = "DELETE"

  destroy_headers = {
    X-Vault-Token = jsondecode(terracurl_request.init.response).root_token
  }

  destroy_response_codes = [
    200,
    201,
    204,
  ]

}