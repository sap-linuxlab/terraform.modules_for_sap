
# SAP NetWeaver AS Primary Application Server (PAS) Dispatcher, sapdp<PAS_NN> process as 32<PAS_NN> port, for SAP GUI, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_abap_pas_dp_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  group     = var.module_var_host_security_group_id
  direction = "outbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}


# SAP NetWeaver AS Primary Application Server (PAS) Gateway, sapgw<PAS_NN> process as 33<PAS_NN> port, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_abap_pas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_abap_pas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}


# SAP NetWeaver AS Primary Application Server (PAS) Gateway Secured, sapgw<PAS_NN>s process as 48<PAS_NN> port, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_abap_pas_gw_secure" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_abap_pas_gw_secure" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}


# SAP NetWeaver AS Primary Application Server (PAS) SAP Start Service (i.e. SAPControl SOAP Web Service) HTTP and HTTPS, sapctrl<PAS_NN> and sapctrls<PAS_NN> processes as 5<PAS_NN>13 and 5<PAS_NN>14 ports, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_ingress_sapnwas_abap_pas_ctrl" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}14")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_egress_sapnwas_abap_pas_ctrl" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}14")
  }
}


# SAP NetWeaver AS Primary Application Server (PAS) ICM HTTPS for Web GUI and SAP Fiori Launchpad (HTTPS), icman process as 443<PAS_NN>, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_abap_pas_icm" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_sapnwas_abap_pas_icm" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")
    port_max = tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")
  }
}
