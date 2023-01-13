
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


# SAP NetWeaver PAS / SAP GUI, access from within the same Subnet
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

# SAP NetWeaver PAS Gateway, access from within the same Subnet
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


# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_icm_https" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_gw]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("43${var.module_var_sap_hana_instance_no}")
    port_max = tonumber("43${var.module_var_sap_hana_instance_no}")
  }
}

# SAP HANA ICM HTTP Internal Web Dispatcher, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_icm_http" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_icm_https]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("80${var.module_var_sap_hana_instance_no}")
    port_max = tonumber("80${var.module_var_sap_hana_instance_no}")
  }
}

# SAP HANA Internal Web Dispatcher, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_webdisp" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_icm_http]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}06")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}06")
  }
}

# SAP HANA indexserver MDC System Tenant SYSDB, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_index_mdc_sysdb" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_webdisp]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}13")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}13")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphana_index_mdc_sysdb" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_webdisp]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}13")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}13")
  }
}

# SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_index_mdc_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_sysdb]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}15")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}15")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphana_index_mdc_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_sysdb]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}15")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}15")
  }
}

# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_saphana_hsr1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("4${var.module_var_sap_hana_instance_no}01")
    port_max = tonumber("4${var.module_var_sap_hana_instance_no}07")
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_saphana_hsr1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("4${var.module_var_sap_hana_instance_no}01")
    port_max = tonumber("4${var.module_var_sap_hana_instance_no}07")
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_saphana_hsr2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("4${var.module_var_sap_hana_instance_no}40")
    port_max = tonumber("4${var.module_var_sap_hana_instance_no}40")
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_saphana_hsr2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("4${var.module_var_sap_hana_instance_no}40")
    port_max = tonumber("4${var.module_var_sap_hana_instance_no}40")
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_pacemaker_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 2224
    port_max = 2224
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_pacemaker_1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 2224
    port_max = 2224
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_pacemaker_2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 3121
    port_max = 3121
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_pacemaker_2" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = 3121
    port_max = 3121
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_pacemaker_3" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  udp {
    port_min = 5404
    port_max = 5412
  }
}

resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_pacemaker_3" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  udp {
    port_min = 5404
    port_max = 5412
  }
}


# SAP NetWeaver AS JAVA Central Instance (CI) ICM server process 0..n, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_java_ci_icm" {
  count      = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}00")
    port_max = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}06")
  }
}


# SAP NetWeaver AS JAVA Central Instance (CI) Access server process 0..n, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_java_ci_access" {
  count      = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}20")
    port_max = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}22")
  }
}

# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services HTTP server process 0..n, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_java_ci_admin_http" {
  count      = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}14")
  }
}

# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services SL Controller server process 0..n, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_java_ci_admin_slcontroller" {
  count      = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}17")
    port_max = tonumber("5${var.module_var_sap_nwas_java_ci_instance_no}19")
  }
}
