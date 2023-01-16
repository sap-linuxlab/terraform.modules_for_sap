
# SAP NetWeaver AS Primary Application Server (PAS) Dispatcher (sapdp), for SAP GUI, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_sapgui"
  priority  = 205
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_sapgui"
  priority  = 206
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

# SAP NetWeaver AS Primary Application Server (PAS) Gateway (sapgw), access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_gw"
  priority  = 207
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_gw"
  priority  = 208
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP Web GUI and SAP Fiori Launchpad (HTTPS), access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapfiori" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapfiori"
  priority  = 209
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("443${var.module_var_sap_hana_instance_no}")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

# SAP NetWeaver sapctrl HTTP and HTTPS, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_ctrl" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_ctrl"
  priority  = 210
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = tonumber("5${var.module_var_sap_nwas_abap_pas_instance_no}13")
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
