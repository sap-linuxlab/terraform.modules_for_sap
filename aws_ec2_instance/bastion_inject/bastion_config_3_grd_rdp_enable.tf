# Note: If login uses root, you do not need "sudo" prefix or "sudo su - root -c 'command here'"
#       For AWS, MS Azure and GCP without initial root login the sudo elevated privilege is required

# RDP = 1 remote view session with 1 user login (new remote login will logout others)
# VNC = many remote view sessions with 1 user login

resource "null_resource" "bastion_config_3" {

  depends_on = [null_resource.bastion_config_2_sleep]

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
    destination = "bastion_config_3.sh"
    content     = <<EOT
#!/bin/bash

### GNOME Remote Desktop (GRD) Remote Login (Multi User), system service (headless) ###
# [DO NOT use GRD Desktop Service, user service]
# https://gitlab.gnome.org/GNOME/gnome-remote-desktop#headless-multi-user-remote-login

os_release=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
os_version=$(grep ^VERSION_ID= /etc/os-release)


# Variables
tf_input_grd_rdp_user="${var.module_var_bastion_grd_rdp_user}"
tf_input_grd_rdp_user_password="${var.module_var_bastion_grd_rdp_user_password}"
tf_input_grd_rdp_port="${var.module_var_bastion_grd_rdp_port}"

if [ -z "$tf_input_grd_rdp_user_password" ]; then
    echo "ERROR: GNOME Remote Desktop (GRD) RDP User Password is blank, exiting..."
    exit 1
fi

echo 'Configure firewalld to allow GRD RDP port'
if [ "$os_release" = 'rhel' ]; then
  dnf --assumeyes --debuglevel=1 install firewalld
elif [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ]; then
  zypper install --no-confirm firewalld
fi
echo 'Activate firewalld'
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" port port="'$tf_input_grd_rdp_port'" protocol="tcp" log prefix="[ALLOW_GRD_RDP]" accept'
# firewall-cmd --permanent --add-service=rdp
# firewall-cmd --permanent --add-port=$tf_input_grd_rdp_port/tcp
firewall-cmd --reload

# Install GRD
if [ "$os_release" = 'rhel' ] || [ "$os_release" = 'centos' ]; then
  dnf --assumeyes --debuglevel=1 gnome-remote-desktop
fi
if [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ] ; then
  zypper --non-interactive install --no-confirm gnome-remote-desktop
fi

# Create user with group wheel
# https://documentation.suse.com/sles/16.0/html/SLE-differences-faq/index.html#sle16-differences-faq-security-sudo
if [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ] ; then
  zypper --non-interactive install --no-confirm sudo-policy-wheel-auth-self
fi
useradd $tf_input_grd_rdp_user --groups wheel
echo "$tf_input_grd_rdp_user_password" | sudo passwd $tf_input_grd_rdp_user --stdin

# Stop/disable GRD before configuration
grdctl --system rdp disable
systemctl --now disable gnome-remote-desktop | tee

# Generate TLS Key and Certificate
# Use symlink path ~gnome-remote-desktop (do not use with double quotes otherwise will cause errors)
openssl req -new -newkey rsa:4096 -days 720 -nodes -x509 -subj "/C=US/ST=NONE/L=NONE/O=GNOME/CN=$(hostname -s)" -out ~gnome-remote-desktop/grd-rdp-tls.crt -keyout ~gnome-remote-desktop/grd-rdp-tls.key
# Debug steps...
# openssl genrsa -out ~gnome-remote-desktop/rdp-tls.key 4096
# openssl req -new -subj "/C=US/ST=NONE/L=NONE/O=GNOME/OU=GNOME/CN=$(hostname -s)" -key ~gnome-remote-desktop/grd-rdp-tls.key -out ~gnome-remote-desktop/grd-rdp-tls.csr
# openssl x509 -req -days 720 -issuer -set_issuer "/CN=$(hostname -s)" -signkey ~gnome-remote-desktop/grd-rdp-tls.key -in ~gnome-remote-desktop/grd-rdp-tls.csr -out ~gnome-remote-desktop/grd-rdp-tls.crt

# Correct file permissions on TLS Key and Certificate
chmod 644 ~gnome-remote-desktop/grd-rdp-tls.crt
chown gnome-remote-desktop:gnome-remote-desktop ~gnome-remote-desktop/grd-rdp-tls.crt
chmod 644 ~gnome-remote-desktop/grd-rdp-tls.key
chown gnome-remote-desktop:gnome-remote-desktop ~gnome-remote-desktop/grd-rdp-tls.key
# chmod 644 ~gnome-remote-desktop/grd-rdp-tls.csr
# chown gnome-remote-desktop:gnome-remote-desktop ~gnome-remote-desktop/grd-rdp-tls.csr

# Configure GRD
grdctl --system rdp clear-credentials
grdctl --system rdp set-tls-key ~gnome-remote-desktop/grd-rdp-tls.key
grdctl --system rdp set-tls-cert ~gnome-remote-desktop/grd-rdp-tls.crt
grdctl --system rdp set-credentials "$tf_input_grd_rdp_user" "$tf_input_grd_rdp_user_password"
grdctl --system rdp disable-view-only
grdctl --system rdp enable-port-negotiation
grdctl --system rdp set-port $tf_input_grd_rdp_port

# Configure SELinux for GRD
getenforce
semanage port -a -t gnome_remote_desktop_port_t -p tcp $tf_input_grd_rdp_port

# Enable GNOME Display Manager (GDM) on boot
systemctl enable --now gdm.service

# Start gnome-remote-desktop-daemon --system (headless)
grdctl --system rdp enable

# Enable GNOME Remote Desktop (GRD) Remote Login on boot
systemctl --system enable gnome-remote-desktop

# Show GRD status
sleep 30
systemctl --system status gnome-remote-desktop | tee
grdctl --system status

# # Debug
# journalctl | grep gnome-remote
# netstat -tunlp | grep gnome-remote
# lsof -P -i TCP -i UDP
# loginctl list-sessions
# firewall-cmd --list-all-zones

  EOT
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/bastion_config_3.sh ; sudo su - root -c 'bash /home/ec2-user/bastion_config_3.sh'"
    ]
  }

}
