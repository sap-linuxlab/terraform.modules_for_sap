
# Execute all scripts pushed to target

resource "null_resource" "execute_os_scripts" {

  depends_on = [
    null_resource.dns_resolv_files,
    null_resource.build_script_fs_init,
    null_resource.build_script_os_prepare,
    azurerm_virtual_machine_data_disk_attachment.volume_attachment_hana_data,
    azurerm_virtual_machine_data_disk_attachment.volume_attachment_hana_log,
    azurerm_virtual_machine_data_disk_attachment.volume_attachment_hana_shared,
    azurerm_virtual_machine_data_disk_attachment.volume_attachment_usr_sap,
    azurerm_virtual_machine_data_disk_attachment.volume_attachment_sapmnt,
    azurerm_virtual_machine_data_disk_attachment.volume_attachment_swap,
    azurerm_virtual_machine_data_disk_attachment.volume_attachment_software
  ]

  connection {
    type                = "ssh"
    user                = "root"
    host                = azurerm_linux_virtual_machine.host.private_ip_address
    private_key         = var.module_var_host_ssh_private_key
    bastion_host        = var.module_var_bastion_ip
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }


  # SSH Timeout experienced randomly, avoiding by adding 60s sleep delay before continuing
  provisioner "local-exec" {
    command = "echo '----Sleep 60s to ensure host is ready-----' && sleep 60"
  }

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      #"mv /etc/resolv.conf /etc/resolv.conf.backup",
      #"mv /tmp/resolv.conf /etc/",
      #"chmod 644 /etc/resolv.conf",
      "chmod +x /root/terraform_*",
      "echo 'Show HOME directory for reference Shell scripts were transferred'",
      "ls -lha $HOME",
      "/root/terraform_dig.sh",
      "/root/terraform_fs_init.sh",
      "/root/terraform_os_prep.sh"
    ]
  }

  # Copy logs back to the Terraform origin/local host
  #provisioner "local-exec" {
  #  command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -W %h:%p bastionuser@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/ssh/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' -i ${path.root}/ssh/hosts_rsa root@${ibm_is_instance.virtual_server.primary_network_interface[0].primary_ipv4_address}:/tmp/terraform_shell_logs_*.zip ${path.root}"
  #}

}
