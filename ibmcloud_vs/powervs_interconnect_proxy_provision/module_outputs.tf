
output "output_proxy_private_ip" {
  value = ibm_is_instance.proxy_virtual_server.primary_network_attachment[0].virtual_network_interface[0].primary_ip[0].address
}

output "output_proxy_host_name" {
  value = ibm_is_instance.proxy_virtual_server.name
}

output "output_proxy_port_squid" {
  value = var.module_var_proxy_port_squid
}

output "output_dns_custom_resolver_ip" {
  value = ibm_dns_custom_resolver.dns_custom_powervs.locations[0].dns_server_ip
}
