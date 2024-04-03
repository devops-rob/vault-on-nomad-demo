#! /bin/bash -e

# Install the CNI Plugins
curl -L https://github.com/containernetworking/plugins/releases/download/v0.9.1/cni-plugins-linux-amd64-v0.9.1.tgz -o /tmp/cni.tgz
mkdir -p /opt/cni/bin
tar -C /opt/cni/bin -xzf /tmp/cni.tgz

# Install Nomad
sudo apt-get update && \
  sudo apt-get install wget gpg coreutils -y

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install nomad -y

# Create Nomad directory.
mkdir -p /etc/nomad.d

# Install Vault
sudo apt-get install vault -y

# Create Vault directory.
mkdir -p /etc/vault.d




# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Install Java
sudo apt install default-jre -y

# Nomad configuration files
cat <<EOF > /etc/nomad.d/nomad.hcl
log_level = "DEBUG"
data_dir = "/etc/nomad.d/data"

client {
  enabled    = true
  node_pool  = "vault-backup"
  node_class = "vault-backup"

  server_join {
    retry_join = ["${NOMAD_SERVERS_ADDR}"]
  }

  host_volume "vault_vol" {
    path      = "/etc/vault.d"
    read_only = false
  }

}

plugin "docker" {
  config {
    allow_privileged = true
  }
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
