
# SAP NetWeaver AS Primary Application Server (PAS) Dispatcher, sapdp<PAS_NN> process as 32<PAS_NN> port, for SAP GUI, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_pas_dp_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_pas_dp_sapgui"
  priority  = 220
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_abap_pas_dp_sapgui" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_pas_dp_sapgui"
  priority  = 221
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("32${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS Primary Application Server (PAS) Gateway, sapgw<PAS_NN> process as 33<PAS_NN> port, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_pas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_pas_gw"
  priority  = 222
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_abap_pas_gw" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_pas_gw"
  priority  = 223
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("33${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS Primary Application Server (PAS) Gateway Secured (with SNC Enabled), sapgw<PAS_NN>s process as 48<PAS_NN> port, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_pas_gw_secure" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_pas_gw_secure"
  priority  = 224
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_abap_pas_gw_secure" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_pas_gw_secure"
  priority  = 225
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("48${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS Primary Application Server (PAS) SAP Start Service (i.e. SAPControl SOAP Web Service) HTTP and HTTPS, sapctrl<PAS_NN> and sapctrls<PAS_NN> processes as 5<PAS_NN>13 and 5<PAS_NN>14 ports, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_pas_ctrl" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_pas_ctrl"
  priority  = 226
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = ["5${var.module_var_sap_nwas_abap_pas_instance_no}13-5${var.module_var_sap_nwas_abap_pas_instance_no}14"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_abap_pas_ctrl" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_pas_ctrl"
  priority  = 227
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = ["5${var.module_var_sap_nwas_abap_pas_instance_no}13-5${var.module_var_sap_nwas_abap_pas_instance_no}14"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS Primary Application Server (PAS) ICM HTTPS for Web GUI and SAP Fiori Launchpad (HTTPS), icman process as 443<PAS_NN>, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_pas_icm" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_pas_icm"
  priority  = 228
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound__sapnwas_abap_pas_icm" {
  count = local.network_rules_sap_nwas_abap_pas_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_pas_icm"
  priority  = 229
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("443${var.module_var_sap_nwas_abap_pas_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
