
# Create Network Interface (NIC) to attach
# By default, the Internal Domain Name Suffix will use ".internal.cloudapp.net" from the Azure Dynamic Host Configuration Protocol (DHCP) is applied to each NIC.
resource "azurerm_network_interface" "host_nic0" {
  name                = "${var.module_var_host_name}-nic-0"
  resource_group_name = local.target_resource_group_name
  location            = var.module_var_az_location_region

  enable_ip_forwarding = var.module_var_disable_ip_anti_spoofing // When disable the Anti IP Spoofing = true, then Enable IP Forwarding = true

  ip_configuration {
    primary                       = "true"
    name                          = "${var.module_var_host_name}-nic-0-link"
    subnet_id                     = local.target_vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = 
    #public_ip_address_id          = 
  }
}


# Create host
resource "azurerm_linux_virtual_machine" "host" {
  name                = var.module_var_host_name
  resource_group_name = local.target_resource_group_name
  location            = var.module_var_az_location_region
  size                = var.module_var_az_vm_instance

  network_interface_ids = [
    azurerm_network_interface.host_nic0.id
  ]

  # Use cloud-init and EOF with dash to trim whitespace
  # Execute sed to enable direct login to root, remove command="echo 'Please login as the user \"user_admin\" rather than the user \"root\".';echo;sleep 10;exit 142"
  # enable_root_login for running SAP software installations
  custom_data = base64encode(<<-EOF
  #!/bin/bash
  sed -i 's/,command=".*ssh-rsa/ ssh-rsa/' /root/.ssh/authorized_keys
  EOF
  )

  computer_name = var.module_var_host_name

  admin_username = "user_admin"
  #admin_password = "Password123!"
  disable_password_authentication = true

  # The Azure VM Agent only allows creating SSH Keys at the path /home/{username}/.ssh/authorized_keys - as such this public key will be written to the authorized keys file
  admin_ssh_key {
    username   = "user_admin"
    public_key = var.module_var_host_ssh_public_key
  }


  ### NOTICE: If using disable_password_authentication = false, and setting a Password, then first usage of sudo su - root.....
  ### causes the following message prompt which breaks the automation and cannot be skipped
  # We trust you have received the usual lecture from the local System
  # Administrator. It usually boils down to these three things:
  #    #1) Respect the privacy of others.
  #    #2) Think before you type.
  #    #3) With great power comes great responsibility.


  source_image_reference {
    publisher = data.azurerm_platform_image.host_os_image.publisher
    offer     = data.azurerm_platform_image.host_os_image.offer
    sku       = data.azurerm_platform_image.host_os_image.sku
    version   = data.azurerm_platform_image.host_os_image.version
  }

  os_disk {
    name                 = "${var.module_var_host_name}-boot"
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
      source_image_reference
    ]
  }

}



# Attach block disk volumes to host

resource "azurerm_virtual_machine_data_disk_attachment" "volume_attachment" {
#  count = length([for vol in azurerm_managed_disk.block_volume : vol.name])
  for_each = azurerm_managed_disk.block_volume

  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_linux_virtual_machine.host.id
  lun                = tostring(10 + index(keys(azurerm_managed_disk.block_volume),each.key))  # Maximum LUN range is 63
  caching            = "None"
}
