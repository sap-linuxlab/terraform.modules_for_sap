
resource "null_resource" "build_script_os_prepare" {

  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type                = "ssh"
    user                = "root"
    host                = ibm_is_instance.virtual_server.primary_network_interface[0].primary_ipv4_address
    private_key         = var.module_var_host_private_ssh_key
    bastion_host        = var.module_var_bastion_floating_ip
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_os_prep.sh"
    content     = <<EOF
#!/bin/bash

# If this script fails to execute with error \r command not found, use below to convert CRLF to LF
#sed -i "s/\r$//" FileName


#############################################
#	Set server hostname
#############################################

set_hostname="${var.module_var_virtual_server_hostname}.${var.module_var_dns_root_domain_name}"
hostnamectl set-hostname $set_hostname
systemctl restart systemd-hostnamed

#echo "hostname --short  == $(hostname --short)"
#echo "hostname --domain == $(hostname --domain)"
#echo "hostname --fqdn   == $(hostname --fqdn)"

#echo "Debug - show hosts file"
#cat /etc/hosts


EOF
  }

}
