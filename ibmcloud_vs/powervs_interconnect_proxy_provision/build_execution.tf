
# Execute all scripts pushed to target

resource "null_resource" "execute_os_scripts" {

  depends_on = [
    null_resource.dns_resolv_update,
    null_resource.bind_files,
    null_resource.nginx_files
  ]

  # Specify the ssh connection
  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type         = "ssh"
    user         = "root"
    host         = ibm_is_instance.proxy_virtual_server.primary_network_interface[0].primary_ipv4_address
    private_key  = var.module_var_host_private_ssh_key
    bastion_host = var.module_var_bastion_floating_ip
    #bastion_host_key = 
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

  # SSH Timeout experienced randomly, avoiding by adding 60s sleep delay before continuing
  provisioner "local-exec" {
    command = "echo '----Sleep 30s to ensure Virtual Server is ready-----' && sleep 30"
  }

  # Execute, including all files provisioned by Terraform into $HOME
  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/terraform_*",
      "echo 'Show HOME directory for reference Shell scripts were transferred'",
      "ls -lha $HOME",
      "if [ -f $HOME/terraform_proxy_dns_bind.sh ]; then $HOME/terraform_proxy_dns_bind.sh ; fi",
      "if [ -f $HOME/terraform_proxy_web_squid.sh ]; then $HOME/terraform_proxy_web_squid.sh ; fi",
      "if [ -f $HOME/terraform_proxy_web_nginx.sh ]; then $HOME/terraform_proxy_web_nginx.sh ; fi"
    ]
  }

  # Copy logs back to the Terraform origin/local host
  #provisioner "local-exec" {
  #  command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand='ssh -W %h:%p bastionuser@${var.module_var_bastion_floating_ip} -p ${var.module_var_bastion_ssh_port} -i ${path.root}/ssh/bastion_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' -i ${path.root}/ssh/hosts_rsa root@${ibm_is_instance.proxy_virtual_server.primary_network_interface[0].primary_ipv4_address}:/tmp/terraform_shell_logs_*.zip ${path.root}"
  #}

}
