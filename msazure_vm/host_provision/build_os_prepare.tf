
resource "null_resource" "build_script_os_prepare" {

  connection {
    type                = "ssh"
    user                = "root"
    host                = azurerm_linux_virtual_machine.host.private_ip_address
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
    destination = "terraform_os_prep.sh"
    content     = <<EOF
#!/bin/bash

# If this script fails to execute with error \r command not found, use below to convert CRLF to LF
#sed -i "s/\r$//" FileName

# Verify OS distribution
export os_type=""
export os_version=""
os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
os_info_version=$(grep ^VERSION_ID= /etc/os-release | awk -F '=' '{print $2}' | tr -d '\"')
if [ "$os_info_id" = "sles" ] || [ "$os_info_id" = "sles_sap" ] ; then os_type="sles" ; fi
if [ "$os_info_id" = "rhel" ] ; then os_type="rhel" ; fi
os_version=$os_info_version


#############################################
#	Set server hostname
#############################################

#echo "--- DEBUG ---"
#cat /etc/hosts
#cat /etc/hostname
#cat /proc/sys/kernel/hostname
#cat /etc/resolv.conf
#cat /etc/dhcp/dhclient.conf


# Host and Domain vars
ip_escaped=$(printf '%q\n' "${azurerm_linux_virtual_machine.host.private_ip_address}")
set_hostname="${var.module_var_host_name}.${var.module_var_dns_root_domain_name}"
set_hostname_only="${var.module_var_host_name}"
set_domain_only="${var.module_var_dns_root_domain_name}"


#### Begin hostname and domain change

echo "Remove existing /etc/hosts record for host"
sed -i "/$ip_escaped.*/d" /etc/hosts

# Set Hostname in /etc/hosts manually
echo -e "$ip_escaped\t$set_hostname\t$set_hostname_only" >> /etc/hosts

# Set Hostname
hostnamectl set-hostname $set_hostname
systemctl restart systemd-hostnamed


if [ "$os_type" = "rhel" ]
then
    #### Reset network interface for hostname and domain to set
    # Reload RHEL Network Manager
    systemctl reload NetworkManager
fi


echo "--- Show hostname and domain details ---"
echo "hostname --short  == $(hostname --short)"
echo "hostname --domain == $(hostname --domain)"
echo "hostname --fqdn   == $(hostname --fqdn)"
echo "uname -n          == $(uname -n)"

#echo "--- Show Ansible Fact for FQDN ---"
#echo "Ansible Facts ansible_fqdn and ansible_domain uses python socket.getfqdn() == "
#python3 -c "import socket; print(socket.getfqdn())"

#echo "--- DEBUG ---"
#cat /etc/hosts
#cat /etc/hostname
#cat /proc/sys/kernel/hostname
#cat /etc/resolv.conf
#cat /etc/dhcp/dhclient.conf

EOF
  }

}
