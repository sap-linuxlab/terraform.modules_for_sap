
resource "null_resource" "build_script_os_user_root" {

  depends_on = [
    null_resource.dns_resolv_files,
    null_resource.build_script_fs_init,
    null_resource.build_script_os_prepare
  ]

  connection {
    type                = "ssh"
    user                = "ec2-user"
    host                = aws_instance.host.private_ip
    private_key         = var.module_var_host_ssh_private_key
    bastion_host        = var.module_var_bastion_ip
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/home/ec2-user/terraform_tmp_remote_exec_inline.sh"
  }

  # enable_root_login for running SAP software installations
  provisioner "remote-exec" {
    inline = [
      "sudo su - root -c 'mv /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup'",
      "sudo su - root -c 'touch /root/.ssh/authorized_keys'",
      "sudo su - root -c 'echo \"${var.module_var_host_ssh_public_key}\" > /root/.ssh/authorized_keys'",
      "sudo su - root -c 'chmod 700 /root/.ssh'",
      "sudo su - root -c 'chmod 600 /root/.ssh/authorized_keys'",
      "sudo su - root -c 'chown -R root:root /root/.ssh'",
      "echo 'Reload sshd service after sshd_config changes'",
      "sudo su - root -c 'systemctl restart sshd'"
    ]
  }

}
