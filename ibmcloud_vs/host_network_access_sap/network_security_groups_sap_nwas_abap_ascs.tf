
# SAP NetWeaver AS ABAP Central Services (ASCS) Dispatcher, sapdp<ASCS_NN> process as 32<ASCS_NN> port, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_abap_ascs_dp" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_abap_ascs_dp" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "outbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}


# SAP NetWeaver AS ABAP Central Services (ASCS) Message Server (MS), sapms<SAPSID> process as 36<ASCS_NN> port, access from within the same Subnet
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


# SAP NetWeaver AS ABAP Central Services (ASCS) Enqueue Server (EN), sapenq<SAPSID> process as 39<ASCS_NN> port, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_abap_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_abap_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "outbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
    port_max = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  }
}


# SAP NetWeaver AS ABAP Central Services (ASCS) SAP Start Service (i.e. SAPControl SOAP Web Service) HTTP and HTTPS, sapctrl<ASCS_NN> and sapctrls<ASCS_NN> processes as 5<ASCS_NN>13 and 5<ASCS_NN>14 ports, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_abap_ascs_ctrl" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}14")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_abap_ascs_ctrl" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "outbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_nwas_abap_ascs_instance_no}14")
  }
}
