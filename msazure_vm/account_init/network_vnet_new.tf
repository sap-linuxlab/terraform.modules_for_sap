
resource "azurerm_virtual_network" "vnet" {
  count               = var.module_var_az_vnet_name_create_boolean ? 1 : 0
  name                = "${var.module_var_resource_prefix}-vnet"
  resource_group_name = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].name : data.azurerm_resource_group.resource_group[0].name
  address_space       = ["10.200.0.0/16"]
  location            = var.module_var_az_region
}


resource "azurerm_subnet" "vnet_subnet" {
  count                = var.module_var_az_vnet_subnet_name_create_boolean ? 1 : 0
  name                 = "${var.module_var_resource_prefix}-vnet-subnet"
  resource_group_name  = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].name : data.azurerm_resource_group.resource_group[0].name
  virtual_network_name = var.module_var_az_vnet_name_create_boolean ? azurerm_virtual_network.vnet[0].name : data.azurerm_virtual_network.vnet[0].name
  address_prefixes     = ["10.200.10.0/24"]
}
