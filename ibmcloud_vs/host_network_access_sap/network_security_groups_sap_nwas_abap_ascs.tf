
# SAP NetWeaver AS ABAP Central Services (ASCS) Message Server (MS), access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "outbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}

# SAP NetWeaver AS ABAP Central Services (ASCS) Enqueue Server (EN), access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "outbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}
