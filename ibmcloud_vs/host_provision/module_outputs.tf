
output "output_host_private_ip" {
  value = ibm_is_instance.virtual_server.primary_network_interface[0].primary_ip[0].address
}

output "output_host_name" {
  value = ibm_is_instance.virtual_server.name
}

