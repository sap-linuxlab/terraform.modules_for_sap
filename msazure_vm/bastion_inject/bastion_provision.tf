
# Create Public IP for Bastion Host
resource "azurerm_public_ip" "bastion_host_publicip" {
  name                = "${var.module_var_resource_prefix}-bastion-publicip"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region
  allocation_method   = "Static"
  #public_ip_address_allocation = "Dynamic"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


# Create Network Interface (NIC) to attach to Bastion host, assign Security Group to NIC
resource "azurerm_network_interface" "bastion_host_nic0" {
  name                = "${var.module_var_resource_prefix}-bastion-nic-0"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region

  ip_configuration {
    primary                       = "true"
    name                          = "${var.module_var_resource_prefix}-bastion-nic-0-publicip-link"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            =
    public_ip_address_id = azurerm_public_ip.bastion_host_publicip.id
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_network_interface_security_group_association" "bastion_host_nic0_sg" {
  network_interface_id      = azurerm_network_interface.bastion_host_nic0.id
  network_security_group_id = azurerm_network_security_group.bastion_vm_sg.id
}


# Create Network Adapter (NIC) to attach to Bastion host, assign Security Group to NIC
resource "azurerm_network_interface" "bastion_host_nic1" {
  name                = "${var.module_var_resource_prefix}-bastion-nic-1"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region

  ip_configuration {
    name                          = "${var.module_var_resource_prefix}-bastion-nic-1-link"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            =
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}


resource "azurerm_network_interface_security_group_association" "bastion_host_nic1_sg" {
  network_interface_id      = azurerm_network_interface.bastion_host_nic1.id
  network_security_group_id = azurerm_network_security_group.bastion_connection_sg.id
}



# Create Bastion Host
resource "azurerm_linux_virtual_machine" "bastion_host" {
  name                = "${var.module_var_resource_prefix}-bastion"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region
  size                = "Standard_B2ms"

  network_interface_ids = [
    azurerm_network_interface.bastion_host_nic0.id,
    azurerm_network_interface.bastion_host_nic1.id
  ]

  #custom_data   = "{\"value\":\"newvalue\"}"

  computer_name = "${var.module_var_resource_prefix}-bastion"

  admin_username = "azvm-user"
  #admin_password = "Password123!"
  disable_password_authentication = true

  # The Azure VM Agent only allows creating SSH Keys at the path /home/{username}/.ssh/authorized_keys - as such this public key will be written to the authorized keys file
  admin_ssh_key {
    username   = "azvm-user"
    public_key = var.module_var_bastion_public_ssh_key
  }


  source_image_reference {
    publisher = data.azurerm_platform_image.bastion_os_image.publisher
    offer     = data.azurerm_platform_image.bastion_os_image.offer
    sku       = data.azurerm_platform_image.bastion_os_image.sku
    version   = data.azurerm_platform_image.bastion_os_image.version
  }


  os_disk {
    name                 = "${var.module_var_resource_prefix}-bastion-boot"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

  lifecycle {
    ignore_changes = [
      source_image_reference,
      tags
    ]
  }

}
