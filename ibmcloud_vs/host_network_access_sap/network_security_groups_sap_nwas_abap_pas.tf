
# SAP NetWeaver AS Primary Application Server (PAS) Dispatcher (sapdp), for SAP GUI, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "outbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}

# SAP NetWeaver AS Primary Application Server (PAS) Gateway (sapgw), access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}

# SAP Web GUI and SAP Fiori Launchpad (HTTPS), access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapfiori" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("443${var.module_var_sap_hana_instance_no}")
    port_max = tonumber("443${var.module_var_sap_hana_instance_no}")
  }
}

# SAP NetWeaver sapctrl HTTP and HTTPS, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_ctrl" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapfiori]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}14")
  }
}
