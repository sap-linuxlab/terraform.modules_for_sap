
# SAP Host Agent with SOAP over HTTP, saphostctrl process as 1128 port, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphostctrl_http_soap" {
  name      = "tcp_inbound_saphostctrl_http_soap"
  priority  = 240
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 1128
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphostctrl_http_soap" {
  name      = "tcp_outbound_saphostctrl_http_soap"
  priority  = 241
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 1128
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}


# SAP Host Agent with SOAP over HTTPS, saphostctrls process as 1129 port, access from within the same Subnet
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_inbound_saphostctrl_https_soap" {
  name      = "tcp_inbound_saphostctrl_https_soap"
  priority  = 242
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 1129
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
resource "azurerm_network_security_rule" "vnet_sg_rule_tcp_outbound_saphostctrl_httsp_soap" {
  name      = "tcp_outbound_saphostctrl_https_soap"
  priority  = 243
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 1129
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
