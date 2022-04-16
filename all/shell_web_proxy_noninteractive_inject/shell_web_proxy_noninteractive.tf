
resource "null_resource" "build_script_web_proxy_noninteractive" {

  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type                = "ssh"
    user                = "root"
    host                = var.module_var_host_private_ip
    private_key         = var.module_var_host_private_ssh_key
    bastion_host        = var.module_var_bastion_boolean ? var.module_var_bastion_floating_ip : null
    bastion_port        = var.module_var_bastion_boolean ? var.module_var_bastion_ssh_port : null
    bastion_user        = var.module_var_bastion_boolean ? var.module_var_bastion_user : null
    bastion_private_key = var.module_var_bastion_boolean ? var.module_var_bastion_private_ssh_key : null
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh

  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_web_proxy_noninteractive.sh"
    content     = <<EOF
    #!/bin/bash

    # For non-interactive login shell, append proxy env var to /root/.bashrc (will not work if using /etc/bashrc or script stored in /etc/profile.d/)
    echo '# For non-interactive login shell, append proxy env var' >> /root/.bashrc

    echo 'web_proxy_url="${var.module_var_web_proxy_url}" && array=("http_proxy" "https_proxy" "ftp_proxy" "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" ) && for i in "$${array[@]}"; do export $i="$web_proxy_url"; done' >> /root/.bashrc

    echo 'web_proxy_exclusion="${var.module_var_web_proxy_exclusion}" && array=("no_proxy" "NO_PROXY" ) && for i in "$${array[@]}"; do export $i="$web_proxy_exclusion"; done' >> /root/.bashrc

EOF
  }

}


resource "null_resource" "exec_web_proxy_noninteractive" {

  depends_on = [null_resource.build_script_web_proxy_noninteractive]

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/terraform_web_proxy_noninteractive.sh ; bash $HOME/terraform_web_proxy_noninteractive.sh"
    ]
  }

  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type                = "ssh"
    user                = "root"
    host                = var.module_var_host_private_ip
    private_key         = var.module_var_host_private_ssh_key
    bastion_host        = var.module_var_bastion_boolean ? var.module_var_bastion_floating_ip : null
    bastion_port        = var.module_var_bastion_boolean ? var.module_var_bastion_ssh_port : null
    bastion_user        = var.module_var_bastion_boolean ? var.module_var_bastion_user : null
    bastion_private_key = var.module_var_bastion_boolean ? var.module_var_bastion_private_ssh_key : null
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

}
