
# SAP NetWeaver PAS / SAP GUI, and RFC connections
### ABAP dispatcher using 32<NN>
### ABAP gateway using 33<NN>
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_sapnwas_sapgui" {
  count = local.network_rules_sap_nwas_abap_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_sapgui"
  priority  = 201
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix       = local.target_vnet_bastion_subnet_range
  source_port_ranges          = tolist([tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}"), tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")])

  destination_address_prefix  = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = tolist([tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}"), tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")])

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_bastion_connection_security_group_name
}


# SAP NetWeaver AS ICM HTTPS (Secure, Port 443 prefix) Instance Number 01
# SAP Web GUI and SAP Fiori Launchpad (HTTPS)
### ABAP ICM HTTPS using 443<NN>, default 00
### Web Dispatcher HTTPS for NWAS PAS using 443<NN>, default 01
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_sapfiori" {
  count = local.network_rules_sap_nwas_abap_boolean ? local.network_rules_sap_hana_boolean ? 1 : 0 : 0
  name      = "tcp_inbound_sapfiori"
  priority  = 203
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix       = local.target_vnet_bastion_subnet_range
  source_port_ranges          = tolist([tonumber("443${var.module_var_sap_hana_instance_no}"), tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")])

  destination_address_prefix  = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = tolist([tonumber("443${var.module_var_sap_hana_instance_no}"), tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")])

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_bastion_connection_security_group_name
}


# SAP NetWeaver sapctrl HTTP/HTTPS from SAP HANA
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_sapctrl" {
  count = local.network_rules_sap_nwas_abap_boolean ? 1 : 0
  name      = "tcp_inbound_sapctrl"
  priority  = 204
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix       = local.target_vnet_bastion_subnet_range
  source_port_ranges          = tolist([tonumber("5${var.module_var_sap_hana_instance_no}13"), tonumber("5${var.module_var_sap_hana_instance_no}14")])

  destination_address_prefix  = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = tolist([tonumber("5${var.module_var_sap_hana_instance_no}13"), tonumber("5${var.module_var_sap_hana_instance_no}14")])

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_bastion_connection_security_group_name
}


# SAP HANA indexserver MDC System Database (SYSTEMDB) using 3<NN>13
# SAP HANA indexserver MDC Tenant #0 SYSTEMDB using 3<NN>15
# SAP HANA indexserver MDC Tenant #1--n using 3<NN>41
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphana" {
  count = local.network_rules_sap_hana_boolean ? 1 : 0
  name      = "tcp_inbound_saphana"
  priority  = 202
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix       = local.target_vnet_bastion_subnet_range
  source_port_ranges          = tolist([tonumber("3${var.module_var_sap_hana_instance_no}13"), tonumber("3${var.module_var_sap_hana_instance_no}41")])

  destination_address_prefix  = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = tolist([tonumber("3${var.module_var_sap_hana_instance_no}13"), tonumber("3${var.module_var_sap_hana_instance_no}41")])

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_bastion_connection_security_group_name
}
