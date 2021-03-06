
# SAP NetWeaver PAS / SAP GUI, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_sapgui" {
  group     = var.module_var_host_security_group_id
  direction = "inbound"
  remote    = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
    port_max = tonumber("32${var.module_var_sap_nwas_pas_instance_no}")
  }
}

# SAP NetWeaver PAS Gateway, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapnwas_gw" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapnwas_sapgui]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
    port_max = tonumber("33${var.module_var_sap_nwas_pas_instance_no}")
  }
}

# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_icm_https" {
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_icm_https]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("80${var.module_var_sap_hana_instance_no}")
    port_max = tonumber("80${var.module_var_sap_hana_instance_no}")
  }
}

# SAP NetWeaver AS JAVA Message Server, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_sapnwas_java_ms" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_icm_http]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("81${var.module_var_sap_nwas_pas_instance_no}")
    port_max = tonumber("81${var.module_var_sap_nwas_pas_instance_no}")
  }
}

# SAP HANA Internal Web Dispatcher, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_webdisp" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_sapnwas_java_ms]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_webdisp]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}13")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}13")
  }
}

# SAP HANA indexserver MDC Tenant #1, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_index_mdc_1" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_sysdb]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("3${var.module_var_sap_hana_instance_no}15")
    port_max = tonumber("3${var.module_var_sap_hana_instance_no}15")
  }
}

# SAP Web GUI and SAP Fiori Launchpad (HTTPS), access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_sapfiori" {
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_sapfiori]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_nwas_pas_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_nwas_pas_instance_no}14")
  }
}


# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_saphana_hsr1" {
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("4${var.module_var_sap_hana_instance_no}01")
    port_max = tonumber("4${var.module_var_sap_hana_instance_no}07")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_outbound_saphana_hsr1" {
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  udp {
    port_min = 5404
    port_max = 5412
  }
}
