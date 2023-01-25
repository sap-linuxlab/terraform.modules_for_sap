
# Execute all scripts pushed to target

resource "null_resource" "execute_os_scripts" {

  depends_on = [
    vsphere_virtual_disk.virtual_disk_hana_data,
    vsphere_virtual_disk.virtual_disk_hana_log,
    vsphere_virtual_disk.virtual_disk_hana_shared,
    vsphere_virtual_disk.virtual_disk_anydb,
    vsphere_virtual_disk.virtual_disk_usr_sap,
    vsphere_virtual_disk.virtual_disk_sapmnt,
    vsphere_virtual_disk.virtual_disk_swap,
    vsphere_virtual_disk.virtual_disk_software,
    null_resource.build_script_fs_init,
    null_resource.build_script_os_prepare,
    null_resource.os_subscription_files,
    vsphere_virtual_machine.host_provision
  ]

  connection {
    type        = "ssh"
    user        = "root"
    host        = vsphere_virtual_machine.host_provision.default_ip_address
    private_key = var.module_var_host_private_ssh_key
    timeout     = "30s"

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "echo 'Show HOME directory for reference Shell scripts were transferred'",
      "ls -lha $HOME",
      "chmod +x $HOME/terraform_*",
      "$HOME/terraform_os_prep.sh",
      "$HOME/terraform_web_proxy_noninteractive.sh",
      "$HOME/terraform_os_subscriptions.sh",
      "$HOME/terraform_fs_init.sh"
    ]
  }

}
