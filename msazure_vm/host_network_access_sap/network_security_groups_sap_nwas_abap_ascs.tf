
# SAP NetWeaver AS ABAP Central Services (ASCS) Dispatcher, sapdp<ASCS_NN> process as 32<ASCS_NN> port, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_ascs_dp" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_abap_ascs_dp"
  priority  = 201
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_abap_ascs_dp" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_abap_ascs_dp"
  priority  = 202
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("32${var.module_var_sap_nwas_abap_ascs_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS ABAP Central Services (ASCS) Message Server (MS), sapms<SAPSID> process as 36<ASCS_NN> port, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_ascs_ms"
  priority  = 203
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_ascs_ms" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_ascs_ms"
  priority  = 204
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("36${var.module_var_sap_nwas_abap_ascs_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS ABAP Central Services (ASCS) Enqueue Server (EN), sapenq<SAPSID> process as 39<ASCS_NN> port, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_ascs_en"
  priority  = 205
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_abap_ascs_en" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_ascs_en"
  priority  = 206
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_range     = tonumber("39${var.module_var_sap_nwas_abap_ascs_instance_no}")
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP NetWeaver AS ABAP Central Services (ASCS) SAP Start Service (i.e. SAPControl SOAP Web Service) HTTP and HTTPS, sapctrl<ASCS_NN> and sapctrls<ASCS_NN> processes as 5<ASCS_NN>13 and 5<ASCS_NN>14 ports, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_inbound_sapnwas_abap_ascs_ctrl" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_inbound_sapnwas_abap_ascs_ctrl"
  priority  = 207
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = ["5${var.module_var_sap_nwas_abap_ascs_instance_no}13-5${var.module_var_sap_nwas_abap_ascs_instance_no}14"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_outbound_sapnwas_abap_ascs_ctrl" {
  count = local.network_rules_sap_nwas_abap_ascs_boolean ? 1 : 0
  name      = "tcp_outbound_sapnwas_abap_ascs_ctrl"
  priority  = 208
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = data.azurerm_subnet.vnet_subnet.address_prefix
  destination_port_ranges     = ["5${var.module_var_sap_nwas_abap_ascs_instance_no}13-5${var.module_var_sap_nwas_abap_ascs_instance_no}14"]
  destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
