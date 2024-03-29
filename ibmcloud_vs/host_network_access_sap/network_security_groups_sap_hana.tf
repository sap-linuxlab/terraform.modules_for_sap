
# SAP HANA ICM HTTPS (Secure) Internal Web Dispatcher, access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_icm_https" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("43${var.module_var_sap_hana_instance_no}")
    port_max = tonumber("43${var.module_var_sap_hana_instance_no}")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphana_icm_https" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
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
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphana_icm_http" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_icm_https]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("80${var.module_var_sap_hana_instance_no}")
    port_max = tonumber("80${var.module_var_sap_hana_instance_no}")
  }
}


# SAP HANA Internal Web Dispatcher, webdispatcher process, access from within the same Subnet
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
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphana_webdisp" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_icm_http]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
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


# SAP HANA for SOAP over HTTP for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
# SAP HANA for SOAP over HTTPS (Secure) for SAP Instance Agent (SAPStartSrv, i.e. host:port/SAPControl?wsdl), access from within the same Subnet
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_inbound_saphana_startsrv_http_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_index_mdc_1]
  group      = var.module_var_host_security_group_id
  direction  = "inbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_hana_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_hana_instance_no}14")
  }
}
resource "ibm_is_security_group_rule" "vpc_sg_rule_tcp_outbound_saphana_startsrv_http_soap" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_inbound_saphana_startsrv_http_soap]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  tcp {
    port_min = tonumber("5${var.module_var_sap_hana_instance_no}13")
    port_max = tonumber("5${var.module_var_sap_hana_instance_no}14")
  }
}



# SAP HANA System Replication
## The port offset is +10000 from the SAP HANA configured ports (e.g. `3<<hdb_instance_no>>15` for MDC Tenant #1).
## More details in README
resource "ibm_is_security_group_rule" "vpc_sg_rule_sap_inbound_saphana_hsr1" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_tcp_outbound_saphana_startsrv_http_soap]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
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
  depends_on = [ibm_is_security_group_rule.vpc_sg_rule_sap_inbound_saphana_hsr1]
  group      = var.module_var_host_security_group_id
  direction  = "outbound"
  remote     = local.target_vpc_subnet_range
  udp {
    port_min = 5404
    port_max = 5412
  }
}
