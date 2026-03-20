
# Select VNet and Subnet

data "azurerm_private_dns_zone" "vnet_private_dns" {
  name                = var.module_var_dns_zone_name
  resource_group_name = var.module_var_az_resource_group_name
}


# The data source for VNet and VNet Subnets do not display attached NAT Gateways,
# and it is not possible to list NAT Gateways with a Terraform data resource
