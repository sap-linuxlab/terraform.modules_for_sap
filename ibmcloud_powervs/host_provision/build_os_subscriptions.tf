
# IBM Power Virtual Server - RHEL OS registration

resource "null_resource" "os_subscription_files" {

  count = var.module_var_os_vendor_enable ? 1 : 0

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_os_subscriptions.sh"
    content     = <<EOF
#!/bin/bash

rht_username="${var.module_var_os_vendor_account_user}"
rht_password="${var.module_var_os_vendor_account_user_passcode}"
web_proxy_ip_port=$(echo ${var.module_var_web_proxy_url} | awk -F '^http[s]?://' '{print $2}')
web_proxy_ip_only=$(echo $web_proxy_ip_port | awk -F ':' '{print $1}')
web_proxy_port_only=$(echo $web_proxy_ip_port | awk -F ':' '{print $2}')
rhel_version=$(grep ^VERSION_ID= /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')

subscription-manager config \
--server.proxy_hostname="$web_proxy_ip_only" \
--server.proxy_port="$web_proxy_port_only"


echo '--------'
echo 'Register system to Red Hat Customer Portal and attach Red Hat subscriptions'
echo '--------'
subscription-manager register \
--username="$rht_username" \
--password="$rht_password" \
--auto-attach

echo '--------'
echo 'Show Red Hat subscriptions available'
echo '--------'
subscription-manager list

echo '--------'
echo 'Check Red Hat subscription status'
echo '--------'
subscription-manager status
status_string=$(subscription-manager status)
status_substring="Overall Status: Invalid"
if [[ "$status_string" == *"$status_substring"* ]]; then
  echo "Detected invalid subscription status, exit with return code 1"
  exit 1
fi

echo '--------'
echo 'Lock Red Hat subscriptions to specific RHEL major.minor version'
echo '--------'
subscription-manager release --set=$rhel_version

echo '--------'
echo 'Enable critical repositories'
echo '--------'
subscription-manager repos \
--enable=rhel-8-for-ppc64le-baseos-rpms \
--enable=rhel-8-for-ppc64le-appstream-rpms \
--enable=rhel-8-for-ppc64le-supplementary-rpms \
--enable=rhel-8-for-ppc64le-resilientstorage-rpms \
--enable=rhel-8-for-ppc64le-highavailability-rpms \
--enable=rhel-8-for-ppc64le-sap-netweaver-rpms \
--enable=rhel-8-for-ppc64le-sap-solutions-rpms \
--enable=rhel-8-for-ppc64le-sap-solutions-eus-rpms

#echo '--------'
#echo 'Enable all repositories (followed by disable of source and debug rpms)'
#echo '--------'
#subscription-manager repos --enable=rhel-8-for-ppc64le*rpms
#subscription-manager repos --disable=*-source-rpms
#subscription-manager repos --disable=*-debug-rpms

echo '--------'
echo 'Show all enabled repositories'
echo '--------'
subscription-manager repos --list-enabled | grep 'Repo ID:'

EOF
  }

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

}
