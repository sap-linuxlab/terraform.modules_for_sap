
resource "null_resource" "build_script_os_prepare" {

  depends_on = [
    aws_volume_attachment.volume_attachment_hana_data,
    aws_volume_attachment.volume_attachment_hana_data_custom,
    aws_volume_attachment.volume_attachment_hana_log,
    aws_volume_attachment.volume_attachment_hana_log_custom,
    aws_volume_attachment.volume_attachment_hana_shared,
    aws_volume_attachment.volume_attachment_hana_shared_custom,
    aws_volume_attachment.volume_attachment_usr_sap,
    aws_volume_attachment.volume_attachment_sapmnt,
    aws_volume_attachment.volume_attachment_swap,
    aws_volume_attachment.volume_attachment_software,
    aws_volume_attachment.volume_attachment_anydb,
    aws_volume_attachment.volume_attachment_anydb_custom
  ]

  connection {
    type                = "ssh"
    user                = "ec2-user"
    host                = aws_instance.host.private_ip
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


#############################################
#	Set server hostname
#############################################

set_hostname="${var.module_var_host_name}.${var.module_var_dns_root_domain_name}"
hostnamectl set-hostname $set_hostname
systemctl restart systemd-hostnamed

#echo "hostname --short  == $(hostname --short)"
#echo "hostname --domain == $(hostname --domain)"
#echo "hostname --fqdn   == $(hostname --fqdn)"

#echo "Debug - show hosts file"
#cat /etc/hosts

EOF
  }

}
