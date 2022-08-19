# Select Resource Group

data "azurerm_resource_group" "resource_group" {
  name = var.module_var_az_resource_group_name
}


# Select VNet and Subnet

data "azurerm_virtual_network" "vnet" {
  name                = var.module_var_az_vnet_name
  resource_group_name = var.module_var_az_resource_group_name
}


data "azurerm_subnet" "vnet_subnet" {
  name                 = var.module_var_az_vnet_subnet_name
  resource_group_name  = var.module_var_az_resource_group_name
  virtual_network_name = var.module_var_az_vnet_name
}

# The data source for VNet and VNet Subnets do not display attached NAT Gateways,
# and it is not possible to list NAT Gateways with a Terraform data resource
