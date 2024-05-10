output "vaul_ui" {
  value = "http://${data.terraform_remote_state.tfc.outputs.nomad_clients_public_ips[0]}:8200/ui"
}