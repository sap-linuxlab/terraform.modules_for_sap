# Create security group for Virtual Machine instances inside VNet
#
# For instance-level protection, the security groups act as virtual firewalls to restrict inbound and outbound traffic
# Apply security group to virtual NIC
#
# Terraform using in-line rules nested instead of standalone declarations of Security Group Rules

resource "azurerm_network_security_group" "bastion_connection_sg" {
  name                = "${var.module_var_resource_prefix}-bastion-proxy-connection-sg"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region

  # Security Group Rule for Host - Allow Inbound Proxy Connection on SSH Port 22 via the Bastion/Jump Host
  security_rule {
    name                       = "inbound_bastion_to_ssh_22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 22
    destination_address_prefix = data.azurerm_subnet.vnet_subnet.address_prefix  # if using local value this will cause error UnknownVal
    source_port_range          = 22
    source_address_prefix      = azurerm_subnet.bastion_subnet.address_prefixes[0]
  }

}


resource "azurerm_network_security_group" "bastion_vm_sg" {
  name                = "${var.module_var_resource_prefix}-bastion-vm-sg"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region

  # Security Group Rule for Bastion/Jump Host - Allow Inbound SSH Port 22 connection from remote (i.e. Public Internet)
  security_rule {
    name                       = "inbound_ssh_22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = 22
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "0.0.0.0/0"
  }

  # Security Group Rule for Bastion/Jump Host - Allow Inbound SSH Port chosen by user for connection from remote (i.e. Public Internet)
  security_rule {
    name                       = "inbound_ssh_custom"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = var.module_var_bastion_ssh_port
    destination_address_prefix = "0.0.0.0/0"
    source_port_range          = "*"
    source_address_prefix      = "0.0.0.0/0"
  }

  # Security Group Rule for Bastion/Jump Host - Allow Outbound SSH Port 22 connection (e.g. to other hosts)
  #  security_rule {
  #    name                       = "outbound_ssh_22"
  #    priority                   = 102
  #    direction                  = "Outbound"
  #    access                     = "Allow"
  #    protocol                   = "Tcp"
  #    destination_port_range     = 22
  #    destination_address_prefix = "0.0.0.0/0"
  #    source_port_range          = 22
  #    source_address_prefix      = "0.0.0.0/0"
  #  }

}


