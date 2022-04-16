
resource "null_resource" "build_script_os_prepare" {

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
    destination = "terraform_os_prep.sh"
    content     = <<EOF
#!/bin/bash

# If this script fails to execute with error \r command not found, use below to convert CRLF to LF
#sed -i "s/\r$//" FileName

#############################################
#	Set server hostname
#############################################

set_hostname="${var.module_var_lpar_hostname}.${var.module_var_dns_root_domain_name}"
hostnamectl set-hostname $set_hostname


#############################################
# Clean hosts file of old records and set new record
#############################################

ip_escaped=$(printf '%q\n' "${openstack_compute_instance_v2.host_provision.access_ip_v4}")

#sed -i "/$ip_escaped.*/d/g" /etc/hosts

#echo "${openstack_compute_instance_v2.host_provision.access_ip_v4} ${var.module_var_lpar_hostname}.${var.module_var_dns_root_domain_name} ${var.module_var_lpar_hostname}" >> /etc/hosts


EOF
  }

}
