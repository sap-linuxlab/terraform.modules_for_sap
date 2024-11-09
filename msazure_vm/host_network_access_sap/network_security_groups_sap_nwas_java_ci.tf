
# SAP NetWeaver AS JAVA Central Instance (CI) ICM server process 0..n, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_java_ci_icm" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_java_ci_icm"
  priority  = 401
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal
  destination_port_ranges    = ["5${var.module_var_sap_nwas_java_ci_instance_no}00-5${var.module_var_sap_nwas_java_ci_instance_no}06"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS JAVA Central Instance (CI) Access server process 0..n, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_java_ci_access" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_java_ci_access"
  priority  = 402
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal
  destination_port_ranges    = ["5${var.module_var_sap_nwas_java_ci_instance_no}20-5${var.module_var_sap_nwas_java_ci_instance_no}22"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services HTTP server process 0..n, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_java_ci_admin_http" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_java_ci_admin_http"
  priority  = 403
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal
  destination_port_ranges    = ["5${var.module_var_sap_nwas_java_ci_instance_no}13-5${var.module_var_sap_nwas_java_ci_instance_no}14"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS JAVA Central Instance (CI) Admin Services SL Controller server process 0..n, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_java_ci_admin_slcontroller" {
  count = local.network_rules_sap_nwas_java_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_java_ci_admin_slcontroller"
  priority  = 404
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal
  destination_port_ranges    = ["5${var.module_var_sap_nwas_java_ci_instance_no}17-5${var.module_var_sap_nwas_java_ci_instance_no}19"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
