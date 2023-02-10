
output "output_bastion_public_ssh_key" {
  value = tls_private_key.bastion_ssh.public_key_openssh
}

output "output_bastion_private_ssh_key" {
  value = tls_private_key.bastion_ssh.private_key_pem
}


output "output_host_public_ssh_key" {
  value = tls_private_key.host_ssh.public_key_openssh
}

output "output_host_private_ssh_key" {
  value = tls_private_key.host_ssh.private_key_pem
}

output "output_dns_zone_name" {
  value = google_dns_managed_zone.private_dns_zone.name
}
