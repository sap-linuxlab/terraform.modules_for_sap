
# Create Public IP for Bastion Host
resource "azurerm_public_ip" "bastion_host_publicip" {
  name                = "${var.module_var_resource_prefix}-bastion-publicip"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_region
  allocation_method   = "Static"
  #public_ip_address_allocation = "Dynamic"
}


# Create Network Interface (NIC) to attach to Bastion host, assign Security Group to NIC
resource "azurerm_network_interface" "bastion_host_nic0" {
  name                = "${var.module_var_resource_prefix}-bastion-nic-0"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_region

  ip_configuration {
    primary                       = "true"
    name                          = "${var.module_var_resource_prefix}-bastion-nic-0-publicip-link"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = 
    public_ip_address_id = azurerm_public_ip.bastion_host_publicip.id
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
  location            = var.module_var_az_region

  ip_configuration {
    name                          = "${var.module_var_resource_prefix}-bastion-nic-1-link"
    subnet_id                     = azurerm_subnet.bastion_subnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = 
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
  location            = var.module_var_az_region
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
      source_image_reference
    ]
  }

}



# Install lots of things - a Connection is defined for each provisioner for easier trace
resource "null_resource" "bastion_setup" {

  depends_on = [
    azurerm_linux_virtual_machine.bastion_host
  ]

  # SSH Timeout experienced randomly, avoiding by adding 1m30s sleep delay before continuing
  provisioner "local-exec" {
    command = <<-EOT
    echo "----Sleep 60s to ensure VM is ready-----"
    sleep 60
    EOT
  }

  # enable_root_login
  # remote execution of the script
  provisioner "remote-exec" {
    inline = [
      "echo 'Create ${var.module_var_bastion_user} without sudoer'",
      "sudo su - root -c 'useradd --create-home ${var.module_var_bastion_user}'",
      "sudo su - root -c 'mkdir -p /home/${var.module_var_bastion_user}/.ssh'",
      "sudo su - root -c 'touch /home/${var.module_var_bastion_user}/.ssh/authorized_keys'",
      "sudo su - root -c 'echo \"${var.module_var_bastion_public_ssh_key}\" > /home/${var.module_var_bastion_user}/.ssh/authorized_keys'",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] ; then sudo su - root -c 'chown -R ${var.module_var_bastion_user}:${var.module_var_bastion_user} /home/${var.module_var_bastion_user}/.ssh' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] ; then sudo su - root -c 'chown -R ${var.module_var_bastion_user}:users /home/${var.module_var_bastion_user}/.ssh' ; fi",
      "sudo su - root -c 'chmod 700 /home/${var.module_var_bastion_user}/.ssh'",
      "sudo su - root -c 'chmod 600 /home/${var.module_var_bastion_user}/.ssh/authorized_keys'",
      "echo '${var.module_var_bastion_user} is created'",
      "echo 'Installing firewalld'",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] ; then echo 'RHEL detected, yum install firewalld' && yum --assumeyes --debuglevel=1 install firewalld ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] ; then echo 'SLES detected, zypper install --no-confirm firewalld' && zypper install --no-confirm firewalld ; fi",
      "echo 'Activate firewalld'",
      "sudo su - root -c 'systemctl start firewalld'",
      "sudo su - root -c 'systemctl enable firewalld'",
      "echo 'Changing SSH Port to within IANA Dynamic Ports range'",
      "sudo su - root -c 'sed -i \"s/#Port 22/Port ${var.module_var_bastion_ssh_port}/\" /etc/ssh/sshd_config'",
      "if [ $(getenforce) = 'Enforcing' ]; then echo 'SELinux status as enforcing/enabled detected, inform SELinux about port change' && sudo su - root -c 'semanage port -a -t ssh_port_t -p tcp ${var.module_var_bastion_ssh_port}'; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"8') ]; then echo 'RHEL 8.x detected, adding port to firewall-cmd' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp --permanent' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"8') ]; then echo 'RHEL 8.x detected, amending /etc/ssh/ssh_config to permit AllowTcpForwarding' && sudo su - root -c 'sed -i \"s/#AllowTcpForwarding yes/AllowTcpForwarding yes/\" /etc/ssh/sshd_config' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"15') ]; then echo 'SLES 15.x detected, adding port to firewall-cmd' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp --permanent' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"15') ]; then echo 'SLES 15.x detected, amending /etc/ssh/ssh_config to permit AllowTcpForwarding' && sudo su - root -c 'sed -i \"s/#AllowTcpForwarding yes/AllowTcpForwarding yes/\" /etc/ssh/sshd_config' ; fi",
      #"sudo firewall-cmd --reload",
      "echo 'Removing Root SSH Login for Bastion from Public IP'",
      "sudo su - root -c 'sed -i \"s/PermitRootLogin yes/PermitRootLogin no/\" /etc/ssh/sshd_config'",
      "echo 'Allowing only Root SSH Login for Bastion from Private IP range of the VNet Subnet (i.e. login to root on Bastion from Host/s only)'",
      "sudo su - root -c 'echo \"Match Address ${local.target_vnet_subnet_range}\" >> /etc/ssh/sshd_config'",
      "sudo su - root -c 'echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config'",
      "echo 'Reload sshd service after sshd_config changes'",
      "sudo su - root -c 'systemctl restart sshd'",
      "echo 'SSH Port now listening on...'",
      "sudo su - root -c 'netstat -tlpn | grep ssh' || echo 'netstat not found, ignoring command'", // Use else command to avoid Terraform breaking error "executing "/tmp/terraform_xxxxxxxxxx.sh": Process exited with status 1". REPLACE WITH: ss -tunlp | grep ssh
      "echo 'Disable azvm-user'",
      "sudo mv /home/azvm-user/.ssh/authorized_keys /home/azvm-user/.ssh/disabled_keys",
      "echo 'Disabled the azvm-user'"
    ]

    connection {
      type        = "ssh"
      user        = "azvm-user"
      private_key = var.module_var_bastion_private_ssh_key
      host        = azurerm_public_ip.bastion_host_publicip.ip_address

      # Required when using RHEL 8.x because /tmp is set with noexec
      # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
      # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
      script_path = "/home/azvm-user/terraform_tmp_remote_exec_inline.sh"
    }
  }

}
