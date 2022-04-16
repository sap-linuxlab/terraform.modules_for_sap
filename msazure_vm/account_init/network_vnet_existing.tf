# Select VNet and Subnet

data "azurerm_virtual_network" "vnet" {
  count               = var.module_var_az_vnet_name_create_boolean ? 0 : 1
  name                = var.module_var_az_vnet_name
  resource_group_name = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].name : data.azurerm_resource_group.resource_group[0].name
}


data "azurerm_subnet" "vnet_subnet" {
  count                = var.module_var_az_vnet_subnet_name_create_boolean ? 0 : 1
  name                 = var.module_var_az_vnet_subnet_name
  resource_group_name  = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].name : data.azurerm_resource_group.resource_group[0].name
  virtual_network_name = var.module_var_az_vnet_name_create_boolean ? azurerm_virtual_network.vnet[0].name : var.module_var_az_vnet_subnet_name
}
