
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_nfs" {
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 2049
    port_max = 2049
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_nfs" {
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 2049
    port_max = 2049
  }
}

