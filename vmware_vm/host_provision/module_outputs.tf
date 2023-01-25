
output "output_host_private_ip" {
  value = vsphere_virtual_machine.host_provision.default_ip_address
}

output "output_host_name" {
  value = vsphere_virtual_machine.host_provision.name
}
