
output "output_dns_zone_name" {
  value = azurerm_private_dns_zone.dns_services_zone.name
}


output "output_bastion_ssh_key_id" {
  value = azurerm_ssh_public_key.bastion_ssh.id
}

output "output_bastion_public_ssh_key" {
  value = tls_private_key.bastion_ssh.public_key_openssh
}

output "output_bastion_private_ssh_key" {
  value = tls_private_key.bastion_ssh.private_key_pem
}


output "output_host_ssh_key_id" {
  value = azurerm_ssh_public_key.host_ssh.id
}

output "output_host_public_ssh_key" {
  value = tls_private_key.host_ssh.public_key_openssh
}

output "output_host_private_ssh_key" {
  value = tls_private_key.host_ssh.private_key_pem
}


output "output_host_security_group_name" {
  value = azurerm_network_security_group.vnet_sg.name
}

output "output_host_security_group_id" {
  value = azurerm_network_security_group.vnet_sg.id
}
