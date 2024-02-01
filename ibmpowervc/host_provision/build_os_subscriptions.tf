
# IBM Power Virtual Server - RHEL OS registration

resource "null_resource" "os_subscription_files" {

  depends_on = [
    openstack_compute_volume_attach_v2.block_volume_attachment
  ]

  count = var.module_var_os_vendor_enable ? 1 : 0

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
    destination = "terraform_os_subscriptions.sh"
    content     = <<EOF
#!/bin/bash

rhel_version=$(grep ^VERSION_ID= /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')

rht_satellite="${var.module_var_os_systems_mgmt_host}"

if [ $rht_satellite == "null" ]
then
  rht_username="${var.module_var_os_vendor_account_user}"
  rht_password="${var.module_var_os_vendor_account_user_passcode}"
  echo '--------'
  echo 'Register system to Red Hat Customer Portal (RHCP) and attach Red Hat subscriptions'
  echo '--------'
  subscription-manager register \
  --username="$rht_username" \
  --password="$rht_password" \
  --auto-attach
else
  rht_org="${var.module_var_os_vendor_account_user}"
  rht_activationkey="${var.module_var_os_vendor_account_user_passcode}"
  echo '--------'
  echo 'Register system to Red Hat Satellite and attach Red Hat subscriptions'
  echo '--------'
  subscription-manager register \
  --serverurl="$rht_satellite" \
  --org="$rht_org" \
  --activationkey="$rht_activationkey"
  # Activation keys cannot be used with --auto-attach
  subscription-manager attach --auto
fi

echo '--------'
echo 'Show Red Hat subscriptions available'
echo '--------'
subscription-manager list

echo '--------'
echo 'Lock Red Hat subscriptions to specific RHEL major.minor version'
echo '--------'
subscription-manager release --set=$rhel_version

#echo '--------'
#echo 'Enable critical repositories'
#echo '--------'
#subscription-manager repos \
#--enable=rhel-8-for-ppc64le-baseos-rpms \
#--enable=rhel-8-for-ppc64le-appstream-rpms \
#--enable=rhel-8-for-ppc64le-supplementary-rpms \
#--enable=rhel-8-for-ppc64le-resilientstorage-rpms \
#--enable=rhel-8-for-ppc64le-highavailability-rpms \
#--enable=rhel-8-for-ppc64le-sap-netweaver-rpms \
#--enable=rhel-8-for-ppc64le-sap-solutions-rpms

echo '--------'
echo 'Enable all repositories (followed by disable of source and debug rpms)'
echo '--------'
subscription-manager repos --enable=rhel-8-for-ppc64le*rpms
subscription-manager repos --disable=*-source-rpms
subscription-manager repos --disable=*-debug-rpms

echo '--------'
echo 'Show all enabled repositories'
echo '--------'
subscription-manager repos --list-enabled | grep 'Repo ID:'

EOF
  }

}
