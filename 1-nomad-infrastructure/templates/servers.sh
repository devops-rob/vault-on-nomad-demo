#! /bin/bash -e

# Install Nomad
sudo apt-get update && \
  sudo apt-get install wget gpg coreutils -y

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install nomad -y

# Create Nomad directory.
mkdir -p /etc/nomad.d


# Nomad configuration files
cat <<EOF > /etc/nomad.d/nomad.hcl
log_level = "DEBUG"
data_dir = "/etc/nomad.d/data"

server {
  enabled          = true
  bootstrap_expect = ${NOMAD_SERVER_COUNT}

  server_join {
    retry_join = ["provider=aws tag_value=${NOMAD_SERVER_TAG} tag_key=${NOMAD_SERVER_TAG_KEY}"]
  }

  oidc_issuer      = "http://${NOMAD_ADDR}:4646"

}


autopilot {
    cleanup_dead_servers      = true
    last_contact_threshold    = "200ms"
    max_trailing_logs         = 250
    server_stabilization_time = "10s"
    enable_redundancy_zones   = false
    disable_upgrade_migration = false
    enable_custom_upgrades    = false
}


EOF

 cat <<EOF > /etc/nomad.d/acl.hcl
 acl = {
   enabled = true
 }
EOF

systemctl enable nomad
systemctl restart nomad
