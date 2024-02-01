
# Execute all scripts pushed to target

resource "null_resource" "execute_os_scripts_generic" {

  depends_on = [
    null_resource.build_script_os_prepare,
    null_resource.os_subscription_files,
    openstack_compute_volume_attach_v2.block_volume_attachment
  ]

  connection {
    type        = "ssh"
    user        = "root"
    host        = openstack_compute_instance_v2.host_provision.access_ip_v4
    private_key = var.module_var_host_private_ssh_key

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
      "$HOME/terraform_os_prep.sh"
    ]
  }

}


resource "null_resource" "execute_os_scripts_web_proxy" {

  depends_on = [
    null_resource.build_script_os_prepare,
    null_resource.os_subscription_files,
    openstack_compute_volume_attach_v2.block_volume_attachment,
    null_resource.execute_os_scripts_generic
  ]

  count = var.module_var_web_proxy_enable ? 1 : 0

  connection {
    type        = "ssh"
    user        = "root"
    host        = openstack_compute_instance_v2.host_provision.access_ip_v4
    private_key = var.module_var_host_private_ssh_key

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "$HOME/terraform_web_proxy_noninteractive.sh"
    ]
  }

}


resource "null_resource" "execute_os_scripts_os_vendor" {

  depends_on = [
    null_resource.build_script_os_prepare,
    null_resource.os_subscription_files,
    openstack_compute_volume_attach_v2.block_volume_attachment,
    null_resource.execute_os_scripts_generic,
    null_resource.execute_os_scripts_web_proxy
  ]

  count = var.module_var_os_vendor_enable ? 1 : 0

  connection {
    type        = "ssh"
    user        = "root"
    host        = openstack_compute_instance_v2.host_provision.access_ip_v4
    private_key = var.module_var_host_private_ssh_key

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "$HOME/terraform_os_subscriptions.sh"
    ]
  }

}
