
output "output_host_private_ip" {
  value = azurerm_linux_virtual_machine.host.private_ip_address
}

output "output_host_name" {
  value = var.module_var_host_name
}
