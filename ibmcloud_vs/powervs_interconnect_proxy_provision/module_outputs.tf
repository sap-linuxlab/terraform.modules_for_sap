
output "output_proxy_private_ip" {
  value = ibm_is_instance.proxy_virtual_server.primary_network_interface[0].primary_ipv4_address
}

output "output_proxy_host_name" {
  value = ibm_is_instance.proxy_virtual_server.name
}

output "output_proxy_port_squid" {
  value = var.module_var_proxy_port_squid
}

