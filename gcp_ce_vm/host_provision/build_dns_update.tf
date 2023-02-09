
# Update DNS resolvers to include the DNS Services private resolvers
#
# The private DNS resolvers are required to resolve the private DNS names
# Any record not found, is forwarded to the default DNS resolvers
#
# Any Linux OS can only have 3 name servers, which is defined when the OS was compiled by the variable "MAXNS" and cannot be changed by cloud-init
#
# Verify success with dig @$dns_services_resolver $dns_record_type $dns_record_name.$dns_services_zone_name
# Requires install of dig, and yum install cannot be executed from inline operator
# The RHEL image contains Network Manager as an inactive service, therefore running systemctl reload NetworkManager.service to refresh DNS Resolvers will have no effect
# Instead flush DNS Cache with systemctl restart nscd.service

resource "null_resource" "dns_resolv_files" {

  depends_on = [
    google_dns_record_set.dns_resource_record_a
  ]

  connection {
    type                = "ssh"
    user                = "admin"
    host                = google_compute_instance.host.network_interface[0].network_ip
    private_key         = var.module_var_host_ssh_private_key
    bastion_host        = var.module_var_bastion_ip
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
    #bastion_host_key = tls_private_key.bastion_ssh.public_key_openssh
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_dig.sh"
    content     = <<EOF
#!/bin/bash

# Verify OS distribution
export os_type=""
export os_version=""

os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
os_info_version=$(grep ^VERSION_ID= /etc/os-release | awk -F '=' '{print $2}' | tr -d '\"')

if [ "$os_info_id" = "sles" ] || [ "$os_info_id" = "sles_sap" ] ; then os_type="sles"
elif [ "$os_info_id" = "rhel" ] ; then os_type="rhel" ; fi
os_version=$os_info_version

echo "Detected $os_type Linux Operating System Distribution"

echo 'Install dig...'
if [ "$os_type" = "rhel" ] ; then yum --disablerepo=*source* --disablerepo=*debug* --disablerepo=*google* --assumeyes --debuglevel=1 install bind-utils ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm bind-utils ; fi

echo '#### Run dig to Private DNS with Domain Name ####'
echo 'Running dig @169.254.169.254 A ${var.module_var_virtual_machine_hostname}.${var.module_var_dns_root_domain_name}'
dig @169.254.169.254 A ${var.module_var_virtual_machine_hostname}.${var.module_var_dns_root_domain_name}

echo '#### Run nslookup ####'
nslookup ${var.module_var_virtual_machine_hostname}.${var.module_var_dns_root_domain_name} | \
if [ $? -ne 0 ]
then
  echo '!!! Exit Terraform execution, failed on nslookup resolution of ${var.module_var_virtual_machine_hostname}.${var.module_var_dns_root_domain_name}'
else
  nslookup ${var.module_var_virtual_machine_hostname}.${var.module_var_dns_root_domain_name}
fi
EOF
  }

}
