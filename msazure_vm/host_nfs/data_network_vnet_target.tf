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

data "azurerm_private_dns_zone" "vnet_private_dns" {
  name                = var.module_var_dns_zone_name
  resource_group_name = var.module_var_az_resource_group_name
}

locals {
  target_resource_group_name = var.module_var_az_resource_group_name
  target_resource_group_id   = data.azurerm_resource_group.resource_group.id

  target_vnet_name = var.module_var_az_vnet_name
  target_vnet_id   = data.azurerm_virtual_network.vnet.id
  target_vnet_guid = data.azurerm_virtual_network.vnet.guid

  target_vnet_subnet_name  = var.module_var_az_vnet_subnet_name
  target_vnet_subnet_id    = data.azurerm_subnet.vnet_subnet.id
  target_vnet_subnet_range = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal

}

# The data source for VNet and VNet Subnets do not display attached NAT Gateways,
# and it is not possible to list NAT Gateways with a Terraform data resource
