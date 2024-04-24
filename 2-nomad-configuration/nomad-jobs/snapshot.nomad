job "vault-backup" {
  namespace   = "vault-cluster"
  datacenters = ["dc1"]
  type        = "batch"
  node_pool   = "vault-backup"

  periodic {

    crons = [
      "@daily"
    ]

    prohibit_overlap = true
  }

  group "vault-backup" {
    count = 1

    constraint {
      attribute = "${node.class}"
      value     = "vault-backup"
    }

    volume "vault_data" {
      type      = "host"
      source    = "vault_vol"
      read_only = false
    }

    task "vault-backup" {
      driver = "docker"

      volume_mount {
        volume      = "vault_data"
        destination = "/vault/file"
        read_only   = false
      }

      config {
        image   = "shipyardrun/tools"
        command = "./scripts/backup.sh"
        volumes = [
          "local/scripts:/scripts"
        ]
      }

      template {
        data = <<EOH
#!/usr/bin/env sh

{{- range nomadService "vault" }}
  vault_addr="http://{{ .Address }}:{{ .Port }}"
  {{- break }}
{{- end }}

# Authenticate to Vault using JWT
vault_token=$(vault write \
  -format json \
  -address $vault_addr \
  auth/jwt/login role="snapshot" jwt="${JWT}" | \
  jq -r '.auth.client_token')

vault login \
  -address=$vault_addr \
  $vault_token

# Find the cluster leader
leader_address=$(curl \
    ${vault_addr}/v1/sys/leader | \
    jq -r '.leader_address')

echo $leader_address
# Take snapshot

date=$(date -I)

vault operator raft snapshot save \
  -address $leader_address \
  "/vault/file/${date}.snap"

EOH

        destination = "local/scripts/backup.sh"
        change_mode = "noop"
        perms       = "777"
      }

      resources {
        cpu    = 100
        memory = 512

      }

      affinity {
        attribute = "${meta.node_id}"
        value     = "${NOMAD_ALLOC_ID}"
        weight    = 100
      }

      identity {
        env         = true
      }

      env {
        JWT = "${NOMAD_TOKEN}"
      }
    }
  }
}
