
resource "azurerm_network_security_rule" "vnet_sg_rule_sap_ingress_nfs" {
  name      = "tcp_inbound_sap_ingress_nfs"
  priority  = 450
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 2049
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}

resource "azurerm_network_security_rule" "vnet_sg_rule_sap_egress_nfs" {
  name      = "tcp_outbound_sap_egress_nfs"
  priority  = 451
  direction = "Outbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range          = "*"
  source_address_prefix      = local.target_vnet_subnet_range
  destination_port_range     = 2049
  destination_address_prefix = local.target_vnet_subnet_range

  resource_group_name         = var.module_var_az_resource_group_name
  network_security_group_name = var.module_var_host_security_group_name
}
