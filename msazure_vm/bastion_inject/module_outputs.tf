output "output_bastion_ip" {
  value = azurerm_public_ip.bastion_host_publicip.ip_address
}

output "output_bastion_security_group_id" {
  value = azurerm_network_security_group.bastion_vm_sg.id
}

output "output_bastion_connection_security_group_id" {
  value = azurerm_network_security_group.bastion_connection_sg.id
}
