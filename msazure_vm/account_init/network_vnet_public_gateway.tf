
# NAT Gateway can be non-zonal or zonal deployment, one per VNet and attached to 1..n VNet Subnets

resource "azurerm_public_ip" "nat_gw_publicip" {
  count               = var.module_var_az_vnet_name_create_boolean ? 1 : 0
  name                = "${var.module_var_resource_prefix}-vnet-nat-gw-publicip"
  location            = var.module_var_az_location_region
  resource_group_name = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].name : data.azurerm_resource_group.resource_group[0].name
  allocation_method   = "Static"
  sku                 = "Standard"
  #zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat_gw" {
  count               = var.module_var_az_vnet_name_create_boolean ? 1 : 0
  name                = "${var.module_var_resource_prefix}-vnet-nat-gw"
  location            = var.module_var_az_location_region
  resource_group_name = var.module_var_az_resource_group_create_boolean ? azurerm_resource_group.resource_group[0].name : data.azurerm_resource_group.resource_group[0].name
  sku_name            = "Standard"
  #idle_timeout_in_minutes = 10
  #zones               = ["1"]
}

resource "azurerm_subnet_nat_gateway_association" "nat_gw_assoc_subnet" {
  count          = var.module_var_az_vnet_name_create_boolean ? 1 : 0
  nat_gateway_id = azurerm_nat_gateway.nat_gw[0].id
  subnet_id      = local.target_vnet_subnet_id
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gw_assoc_ip" {
  count                = var.module_var_az_vnet_name_create_boolean ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.nat_gw[0].id
  public_ip_address_id = azurerm_public_ip.nat_gw_publicip[0].id
}
