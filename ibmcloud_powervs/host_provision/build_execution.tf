
# Execute all scripts pushed to target

resource "null_resource" "execute_os_scripts_generic" {

  depends_on = [
    null_resource.build_script_os_prepare,
    null_resource.build_script_web_proxy_noninteractive,
    null_resource.os_subscription_files,
    null_resource.dns_resolv_files
  ]

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "echo 'Show HOME directory for reference Shell scripts were transferred'",
      "ls -lha $HOME",
      "chmod +x $HOME/terraform_*",
      "$HOME/terraform_os_prep.sh"
    ]
  }

  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type         = "ssh"
    user         = "root"
    host         = ibm_pi_instance.host_via_certified_profile.pi_network[0].ip_address
    private_key  = var.module_var_host_private_ssh_key
    bastion_host = var.module_var_bastion_ip
    #bastion_host_key = 
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

}


resource "null_resource" "execute_os_scripts_web_proxy" {

  depends_on = [
    null_resource.build_script_os_prepare,
    null_resource.build_script_web_proxy_noninteractive,
    null_resource.os_subscription_files,
    null_resource.dns_resolv_files,
    null_resource.execute_os_scripts_generic
  ]

  count = var.module_var_web_proxy_enable ? 1 : 0

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "$HOME/terraform_web_proxy_noninteractive.sh"
    ]
  }


  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type         = "ssh"
    user         = "root"
    host         = ibm_pi_instance.host_via_certified_profile.pi_network[0].ip_address
    private_key  = var.module_var_host_private_ssh_key
    bastion_host = var.module_var_bastion_ip
    #bastion_host_key = 
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

}


resource "null_resource" "execute_os_scripts_os_vendor" {

  depends_on = [
    null_resource.build_script_os_prepare,
    null_resource.build_script_web_proxy_noninteractive,
    null_resource.os_subscription_files,
    null_resource.dns_resolv_files,
    null_resource.execute_os_scripts_generic,
    null_resource.execute_os_scripts_web_proxy
  ]

  count = var.module_var_os_vendor_enable ? 1 : 0

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "$HOME/terraform_os_subscriptions.sh"
    ]
  }


  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type         = "ssh"
    user         = "root"
    host         = ibm_pi_instance.host_via_certified_profile.pi_network[0].ip_address
    private_key  = var.module_var_host_private_ssh_key
    bastion_host = var.module_var_bastion_ip
    #bastion_host_key = 
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

}


resource "null_resource" "execute_os_scripts_dns" {

  depends_on = [
    null_resource.build_script_os_prepare,
    null_resource.build_script_web_proxy_noninteractive,
    null_resource.os_subscription_files,
    null_resource.dns_resolv_files,
    null_resource.execute_os_scripts_generic,
    null_resource.execute_os_scripts_web_proxy,
    null_resource.execute_os_scripts_os_vendor
  ]

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "echo 'Change DNS in resolv.conf'",
      "if [ -f /tmp/resolv.conf ]; then mv /etc/resolv.conf /etc/resolv.conf.backup && mv /tmp/resolv.conf /etc/ ; fi",
      "chmod 644 /etc/resolv.conf",
      "$HOME/terraform_dig.sh"
    ]
  }


  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type         = "ssh"
    user         = "root"
    host         = ibm_pi_instance.host_via_certified_profile.pi_network[0].ip_address
    private_key  = var.module_var_host_private_ssh_key
    bastion_host = var.module_var_bastion_ip
    #bastion_host_key = 
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

}
