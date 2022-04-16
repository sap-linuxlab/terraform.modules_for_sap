
resource "null_resource" "build_script_web_proxy_noninteractive" {

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

    echo '---- Sleep 60s to ensure Web Proxy connection is ready -----' && sleep 60

    web_proxy_ip_port=$(echo ${var.module_var_web_proxy_url} | awk -F '^http[s]?://' '{print $2}')
    web_proxy_ip_only=$(echo $web_proxy_ip_port | awk -F ':' '{print $1}')

    echo 'Show ip route get to the Web Proxy IP'
    ip route get $web_proxy_ip_only

    echo 'Run cURL test to launchpad.support.sap.com to check internet connectivity'
    curl --connect-timeout 5 --max-time 60 --retry 5 --retry-delay 30 --proxy $web_proxy_ip_port -L launchpad.support.sap.com
    #curl --silent $web_proxy_ip_only >/dev/null && echo 'Connected to squid web proxy' || echo 'Failed to test direct connection to squid web proxy'

EOF
  }

}
