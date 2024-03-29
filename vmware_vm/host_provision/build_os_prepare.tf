
resource "null_resource" "build_script_os_prepare" {

  depends_on = [
    vsphere_virtual_machine.host_provision
  ]

  # Specify the ssh connection
  connection {
    type        = "ssh"
    user        = "root"
    host        = vsphere_virtual_machine.host_provision.default_ip_address
    private_key = var.module_var_host_private_ssh_key
    timeout     = "30s"
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

#############################################
#	Set server hostname
#############################################

set_hostname="${var.module_var_vmware_vm_hostname}.${var.module_var_vmware_vm_dns_root_domain_name}"
hostnamectl set-hostname $set_hostname
systemctl restart systemd-hostnamed

#echo "hostname --short  == $(hostname --short)"
#echo "hostname --domain == $(hostname --domain)"
#echo "hostname --fqdn   == $(hostname --fqdn)"

#echo "Debug - show hosts file"
#cat /etc/hosts


#############################################
# Clean hosts file of old records and set new record
#############################################

ip_escaped=$(printf '%q\n' "${vsphere_virtual_machine.host_provision.default_ip_address}")

#sed -i "/$ip_escaped.*/d/g" /etc/hosts

#echo "${vsphere_virtual_machine.host_provision.default_ip_address} ${var.module_var_vmware_vm_hostname}.${var.module_var_vmware_vm_dns_root_domain_name} ${var.module_var_vmware_vm_hostname}" >> /etc/hosts


EOF
  }

}
