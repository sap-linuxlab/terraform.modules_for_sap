# Create security group for Virtual Machine instances inside VNet
#
# For instance-level protection, the security groups act as virtual firewalls to restrict inbound and outbound traffic
# Apply security group to virtual NIC
#
# Terraform using in-line rules nested instead of standalone declarations of Security Group Rules

resource "azurerm_network_security_group" "vnet_sg" {
  name                = "${var.module_var_resource_prefix}-vnet-vm-sg"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region


  # Allow Outbound HTTP Port 80 connection to any (e.g. via NAT Gateway)
  security_rule {
    name                       = "outbound_http_80"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 80
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }

  # Allow Outbound HTTPS Port 443 connection to any (e.g. via NAT Gateway)
  security_rule {
    name                       = "outbound_https_443"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 443
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }


  # Allow ping inbound from other hosts within the same Subnet
  # Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
  security_rule {
    name                       = "inbound_icmp_ping"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    destination_port_range     = 8
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }

  # Allow ping outbound from hosts to any network, only for Subnet containing hosts (i.e. not for Bastion Subnet)
  # Permits all ICMP Types (and the Codes within the Types) - https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xml
  security_rule {
    name                       = "outbound_icmp_ping"
    priority                   = 103
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    destination_port_range     = 8
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }


  # SSH Inbound/Outbound from hosts within private VNet Subnet
  security_rule {
    name                       = "inbound_ssh_22"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 22
    destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix
    source_port_range          = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "outbound_ssh_22"
    priority                   = 105
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 22
    destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix
    source_port_range          = "*"
    source_address_prefix      = "*"
  }


  # Allow DNS Port 53 connection to Private DNS resolvers
  # azureprivatedns.net / 168.63.129.16
  # https://docs.microsoft.com/azure/virtual-network/what-is-ip-address-168-63-129-16
  security_rule {
    name                       = "outbound_dns_tcp_53"
    priority                   = 106
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 53
    destination_address_prefix = "168.63.129.16"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }
  security_rule {
    name                       = "outbound_dns_udp_53"
    priority                   = 107
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    destination_port_range     = 53
    destination_address_prefix = "168.63.129.16"
    source_port_range          = "*"
    source_address_prefix      = "*"
  }

}
