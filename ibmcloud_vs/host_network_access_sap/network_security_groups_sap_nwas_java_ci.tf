
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
