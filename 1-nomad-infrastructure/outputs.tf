output "nomad_server_public_ip" {
  value = aws_eip.nomad_server.public_ip
}

output "nomad_server_private_ip" {
  value = aws_instance.nomad_servers.private_ip
}

output "nomad_clients_private_ips" {
  value = aws_instance.nomad_clients.*.private_ip
}

output "nomad_clients_public_ips" {
  value = aws_instance.nomad_clients.*.public_ip
}


output "terraform_management_token" {
  value     = nomad_acl_token.terraform.secret_id
  sensitive = true
}

output "nomad_ui" {
  value = "http://${aws_eip.nomad_server.public_ip}:4646"
}