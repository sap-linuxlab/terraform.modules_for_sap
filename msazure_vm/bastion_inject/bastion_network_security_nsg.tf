# Create network security group for VNet Subnet (instead of legacy Network ACL)
#
# For subnet-level protection, limit a subnet’s inbound and outbound traffic
#
# Terraform using in-line rules nested instead of standalone declarations of Security Group Rules

resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "${var.module_var_resource_prefix}-bastion-subnet-nsg"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_region

  security_rule {
    name                       = "inbound_tcp_all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 22
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }

}


#resource "azurerm_subnet_network_security_group_association" "bastion_nsg_attach_subnet" {
#  subnet_id                 = azurerm_subnet.bastion_subnet.id
#  network_security_group_id = azurerm_network_security_group.bastion_nsg.id
#}
