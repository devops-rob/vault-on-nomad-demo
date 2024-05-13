resource "nomad_namespace" "vault" {
  name        = "vault-cluster"
  description = "Vault servers namespace"
}

resource "nomad_job" "vault" {
  jobspec = file("${path.cwd}/files/vault.nomad")
  depends_on = [
    nomad_namespace.vault
  ]
}

resource "terracurl_request" "init" {
  method         = "POST"
  name           = "init"
  response_codes = [200]
  url            = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/v1/sys/init"

  request_body   = <<EOF
{
  "secret_shares": 3,
  "secret_threshold": 2
}
EOF
  max_retry      = 7
  retry_interval = 10

  depends_on = [
    nomad_job.vault
  ]
}

output "init" {
  value = terracurl_request.init.response
}

resource "nomad_variable" "unseal" {
  path      = "nomad/jobs/vault-unsealer"
  namespace = "vault-cluster"

  items = {
    key1 = jsondecode(terracurl_request.init.response).keys[0]
    key2 = jsondecode(terracurl_request.init.response).keys[1]
    key3 = jsondecode(terracurl_request.init.response).keys[2]
  }
}

resource "nomad_job" "vault-unsealer" {
  jobspec = file("${path.cwd}/files/vault-unsealer.nomad")
  depends_on = [
    nomad_namespace.vault,
    nomad_variable.unseal,
    nomad_job.vault
  ]
}

