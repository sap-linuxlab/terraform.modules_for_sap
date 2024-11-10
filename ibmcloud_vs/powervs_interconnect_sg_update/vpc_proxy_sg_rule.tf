
# Security Group Rule for Proxy Host - Allow Inbound DNS Port 53 to relay DNS requests from IBM Power VS hosts to Private DNS
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_inbound_dns_tcp" {
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = var.module_var_power_network_private_subnet

  tcp {
    port_min = 53
    port_max = 53
  }
}


# Security Group Rule for Proxy Host - Allow Inbound DNS Port 53 to relay DNS requests from IBM Power VS hosts to Private DNS
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_inbound_dns_udp" {
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = var.module_var_power_network_private_subnet

  udp {
    port_min = 53
    port_max = 53
  }
}


# Security Group Rule for Proxy Host - Allow Inbound defined proxy port to relay HTTP/HTTPS from IBM Power VS hosts to destination (public internet or IBM Cloud private network backbone)
resource "ibm_is_security_group_rule" "vpc_sg_rule_bastion_inbound_proxy_http" {
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = var.module_var_power_network_private_subnet

  tcp {
    port_min = 50888
    port_max = 50888
  }
}
