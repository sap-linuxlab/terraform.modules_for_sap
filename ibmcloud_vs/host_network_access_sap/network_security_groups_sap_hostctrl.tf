
# SAP Host Agent with SOAP over HTTP, saphostctrl process as 1128 port, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphostctrl_http_soap" {
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 1128
    port_max = 1128
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphostctrl_http_soap" {
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 1128
    port_max = 1128
  }
}


# SAP Host Agent with SOAP over HTTPS, saphostctrls process as 1129 port, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphostctrl_https_soap" {
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 1129
    port_max = 1129
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphostctrl_https_soap" {
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 1129
    port_max = 1129
  }
}
