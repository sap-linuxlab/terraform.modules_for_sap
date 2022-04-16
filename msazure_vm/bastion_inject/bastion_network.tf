
# Create Subnet for Bastion/Jump Host on the VNet

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "${var.module_var_resource_prefix}-bastion-subnet"
  resource_group_name  = local.target_resource_group_name
  virtual_network_name = local.target_vnet_name
  address_prefixes     = ["10.200.240.0/28"]
}
