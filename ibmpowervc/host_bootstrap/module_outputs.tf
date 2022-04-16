
output "output_host_ssh_key_name" {
  value = openstack_compute_keypair_v2.host_ssh.name
}

output "output_host_public_ssh_key" {
  value = tls_private_key.host_ssh.public_key_openssh
}

output "output_host_private_ssh_key" {
  value = tls_private_key.host_ssh.private_key_pem
}
