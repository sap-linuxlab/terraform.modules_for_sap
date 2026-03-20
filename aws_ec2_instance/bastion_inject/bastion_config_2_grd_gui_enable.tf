# Note: If login uses root, you do not need "sudo" prefix or "sudo su - root -c 'command here'"
#       For AWS, MS Azure and GCP without initial root login the sudo elevated privilege is required

resource "null_resource" "bastion_config_2" {

  depends_on = [null_resource.bastion_config_1]

  count = var.module_var_bastion_grd_rdp_enable ? 1 : 0

  # Specify the ssh connection
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.module_var_bastion_private_ssh_key
    host        = aws_instance.bastion_host.public_ip
    port        = var.module_var_bastion_ssh_port
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "bastion_config_2.sh"
    content     = <<EOF
#!/bin/bash

# Variables
tf_input_grd_rdp_user_password="${var.module_var_bastion_grd_rdp_user_password}"

if [ -z "$tf_input_grd_rdp_user_password" ]; then
    echo "ERROR: GNOME Remote Desktop (GRD) RDP User Password is blank, exiting..."
    exit 1
fi

os_release=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
os_version=$(grep ^VERSION_ID= /etc/os-release)

if [ "$os_release" = 'rhel' ] || [ "$os_release" = 'centos' ]; then
  # Install GNOME GUI
  dnf --assumeyes --debuglevel=1 groupinstall "Server with GUI"
  systemctl set-default graphical.target
  systemctl default
fi

if [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ] ; then
  # Install GNOME GUI
  zypper --non-interactive install --no-confirm -t pattern gnome_basic
  systemctl set-default graphical.target
  systemctl default
fi

# Reboot
echo "Rebooting VM for changes to take effect"
(sleep 2 && sudo reboot)&

EOF
  }

  provisioner "remote-exec" {
    inline = [
      "echo '---- Sleep 30s to ensure bastion host is ready -----' && sleep 30",
      "chmod +x /home/ec2-user/bastion_config_2.sh ; sudo su - root -c 'bash /home/ec2-user/bastion_config_2.sh'"
    ]
  }

}


resource "null_resource" "bastion_config_2_sleep" {
  depends_on = [null_resource.bastion_config_2]
  count      = var.module_var_bastion_grd_rdp_enable ? 1 : 0
  provisioner "local-exec" {
    command = "echo '----Sleep 30s to ensure VM is ready-----' && sleep 30"
  }
}
