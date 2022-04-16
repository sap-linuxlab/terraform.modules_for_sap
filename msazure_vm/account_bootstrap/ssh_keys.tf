
# Create private SSH key only for Bastion/Jump Host usage
resource "tls_private_key" "bastion_ssh" {
  algorithm = "RSA"
}

# Public SSH key used to connect to the servers
### use trimspace function to avoid error "<<-EOT # forces replacement", which populates with the same value each time. Alternative: lifecycle {ignore_changes = ["public_key"]}
resource "azurerm_ssh_public_key" "bastion_ssh" {
  name                = "${var.module_var_resource_prefix}-bastion-ssh-key"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_region
  public_key          = trimspace(tls_private_key.bastion_ssh.public_key_openssh)
}


# Create private SSH key for ssh connection of the hosts
resource "tls_private_key" "host_ssh" {
  algorithm = "RSA"
}

# Public SSH key used to connect to the servers
### use trimspace function to avoid error "<<-EOT # forces replacement", which populates with the same value each time. Alternative: lifecycle {ignore_changes = ["public_key"]}
resource "azurerm_ssh_public_key" "host_ssh" {
  name                = "${var.module_var_resource_prefix}-host-ssh-key"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_region
  public_key          = trimspace(tls_private_key.host_ssh.public_key_openssh)
}


##############################################################
# DEBUG Bastion - Display key values, shown after successful execution
##############################################################

#output "bastion_display_private_key" {
#  value = "\n${tls_private_key.bastion_ssh.private_key_pem}"
#}

#output "bastion_display_public_key" {
#  value = "public_key_openssh is:\n ${tls_private_key.bastion_ssh.public_key_openssh}"
#}

##############################################################
# DEBUG Bastion - Display key values, shown before execution but with poor output
##############################################################

#resource "null_resource" "bastion_show_keys" {
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.bastion_ssh.private_key_pem}'"
#  }
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.bastion_ssh.public_key_openssh}'"
#  }
#}


##############################################################
# DEBUG Display key values, shown after successful execution
##############################################################

#output "host_display_private_key" {
#  value = "\n${tls_private_key.host_ssh.private_key_pem}"
#}

#output "host_display_public_key" {
#  value = "public_key_openssh:\n ${tls_private_key.host_ssh.public_key_openssh}"
#}

##############################################################
# DEBUG Display key values, shown before execution but with poor output
##############################################################

#resource "null_resource" "host_show_keys" {
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.host_ssh.private_key_pem}'"
#  }
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.host_ssh.public_key_openssh}'"
#  }
#}
