job "vault-init" {
  datacenters = ["dc1"]

  group "vault-group" {
    task "init-vault" {
      driver = "docker"

      config {
        image = "vault:latest"
        command = ["/bin/sh", "-c", "vault operator init -format=json -key-shares=3 -key-threshold=2 | jq"]
      }

      env {
        VAULT_ADDR = "$NOMAD_ADDR_vault_cluster_0"
      }

      resources {
        cpu    = 500
        memory = 256
      }

      template {
        data = <<EOF
root_token = "${root_token}"
key1 = "${key1}"
key2 = "${key2}"
key3 = "${key3}"
EOF

        destination = "secrets/init_vault.hcl"
      }
    }
  }
}
