
resource "null_resource" "build_script_web_proxy_noninteractive" {

  depends_on = [
    openstack_compute_volume_attach_v2.volume_attachment_hana_data,
    openstack_compute_volume_attach_v2.volume_attachment_hana_log,
    openstack_compute_volume_attach_v2.volume_attachment_hana_shared,
    openstack_compute_volume_attach_v2.volume_attachment_usr_sap,
    openstack_compute_volume_attach_v2.volume_attachment_sapmnt,
    openstack_compute_volume_attach_v2.volume_attachment_swap,
    openstack_compute_volume_attach_v2.volume_attachment_software
  ]

  # Specify the ssh connection
  connection {
    type        = "ssh"
    user        = "root"
    host        = openstack_compute_instance_v2.host_provision.access_ip_v4
    private_key = var.module_var_host_private_ssh_key
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
