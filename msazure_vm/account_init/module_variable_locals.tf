
locals {
  target_resource_group_name = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].name : data.azurerm_resource_group.resource_group[0].name
  target_resource_group_id   = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].id : data.azurerm_resource_group.resource_group[0].id

  target_vnet_name = var.module_var_az_vnet_name_create_boolean ? azurerm_virtual_network.vnet[0].name : var.module_var_az_vnet_name
  target_vnet_id   = var.module_var_az_vnet_name_create_boolean ? azurerm_virtual_network.vnet[0].id : data.azurerm_virtual_network.vnet[0].id
  target_vnet_guid = var.module_var_az_vnet_name_create_boolean ? azurerm_virtual_network.vnet[0].guid : data.azurerm_virtual_network.vnet[0].guid

  target_vnet_subnet_name  = var.module_var_az_vnet_subnet_name_create_boolean ? azurerm_subnet.vnet_subnet[0].name : var.module_var_az_vnet_subnet_name
  target_vnet_subnet_id    = var.module_var_az_vnet_subnet_name_create_boolean ? azurerm_subnet.vnet_subnet[0].id : data.azurerm_subnet.vnet_subnet[0].id
  target_vnet_subnet_range = var.module_var_az_vnet_subnet_name_create_boolean ? azurerm_subnet.vnet_subnet[0].address_prefixes[0] : data.azurerm_subnet.vnet_subnet[0].address_prefixes[0]

}

# The data source for VNet and VNet Subnets do not display attached NAT Gateways,
# and it is not possible to list NAT Gateways with a Terraform data resource
