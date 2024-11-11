
# IBM Power Virtual Server - Update DNS resolvers to include the DNS Services private resolvers
#
# The private DNS resolvers are required to resolve the private DNS names
# Any record not found, is forwarded to the default DNS resolvers
#
# Private DNS resolvers by the DNS Services (161.26.0.7, 161.26.0.8) must be added to the Virtual Server within the VPC
#
# For IBM Power Virtual Servers to share the same Private DNS, a DNS Proxy must be used. The DNS can be set for an entire VLAN if desired, this automation only amends the necessary hosts
#
# Any Linux OS can only have 3 name servers, which is defined when the OS was compiled by the variable "MAXNS" and cannot be changed by cloud-init


# Verify success with dig @$dns_services_resolver $dns_record_type $dns_record_name.$dns_services_zone_name
# Requires install of dig, and yum install cannot be executed from inline operator
# The RHEL image contains Network Manager as an inactive service, therefore running systemctl reload NetworkManager.service to refresh DNS Resolvers will have no effect
# Instead flush DNS Cache with systemctl restart nscd.service

resource "null_resource" "dns_resolv_files" {

  depends_on = [
    ibm_dns_resource_record.dns_resource_record_a,
    ibm_dns_resource_record.dns_resource_record_cname,
    ibm_dns_resource_record.dns_resource_record_ptr
  ]

  # Removed 'nameserver ${var.module_var_dns_proxy_ip}' as proxy for DNS Resolver not required for IBM Power Workspaces that use backend Power Edge Router (PER)
  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "/tmp/resolv.conf"
    content     = <<EOF
nameserver ${var.module_var_dns_custom_resolver_ip}
nameserver 161.26.0.10
nameserver 161.26.0.11
EOF
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

echo '---- Sleep 30s to ensure Virtual Server is ready -----' && sleep 30

echo 'Install dig...'
if [ "$os_type" = "rhel" ] ; then yum --assumeyes --debuglevel=1 install bind-utils ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm bind-utils ; fi

echo '#### Run dig to Private DNS with Domain Name ####'
echo 'Running dig @${var.module_var_dns_custom_resolver_ip} A ${ibm_pi_instance.host_via_certified_profile.pi_instance_name}.${var.module_var_dns_root_domain_name}'
dig @${var.module_var_dns_custom_resolver_ip} A ${ibm_pi_instance.host_via_certified_profile.pi_instance_name}.${var.module_var_dns_root_domain_name}

echo '#### Run nslookup ####'
nslookup ${ibm_pi_instance.host_via_certified_profile.pi_instance_name}.${var.module_var_dns_root_domain_name} | \
if [ $? -ne 0 ]
then
  echo '!!! Exit Terraform execution, failed on nslookup resolution of ${ibm_pi_instance.host_via_certified_profile.pi_instance_name}.${var.module_var_dns_root_domain_name}'
else
  nslookup ${ibm_pi_instance.host_via_certified_profile.pi_instance_name}.${var.module_var_dns_root_domain_name}
fi

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

