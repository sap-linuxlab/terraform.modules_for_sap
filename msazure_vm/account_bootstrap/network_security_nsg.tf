# Create network security group for VNet Subnet (instead of legacy Network ACL)
#
# For subnet-level protection, limit a subnet’s inbound and outbound traffic
#
# Terraform using in-line rules nested instead of standalone declarations of Security Group Rules

resource "azurerm_network_security_group" "vnet_nsg" {
  name                = "${var.module_var_resource_prefix}-vmet-subnet-nsg"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_region

  # Allow ping outbound only
  # Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
  security_rule {
    name                       = "outbound_icmp_ping"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    destination_port_range     = 8
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "outbound_tcp_all"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "*"
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "inbound_tcp_all"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "*"
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "outbound_udp_all"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    destination_port_range     = "*"
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "inbound_udp_all"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    destination_port_range     = "*"
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }

}


resource "azurerm_subnet_network_security_group_association" "vnet_nsg_attach_subnet" {
  subnet_id                 = local.target_vnet_subnet_id
  network_security_group_id = azurerm_network_security_group.vnet_nsg.id
}
