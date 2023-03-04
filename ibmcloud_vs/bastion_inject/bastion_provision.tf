
# Create Bastion/Jump Host Virtual Server

resource "ibm_is_instance" "bastion_host" {

  resource_group = var.module_var_resource_group_id
  name           = "${var.module_var_resource_prefix}-bastion"
  profile        = "cx2-4x8"
  vpc            = local.target_vpc_id
  zone           = local.target_vpc_availability_zone
  image          = data.ibm_is_image.bastion_os_image.id // Must use Image ID
  keys           = [var.module_var_bastion_ssh_key_id]

  # The Subnet assigned to the Primary Network Interface cannot be changed
  # The Name and Security Group assigned to the Primary Network Interface are editable
  primary_network_interface {
    name            = "${var.module_var_resource_prefix}-bastion-nic-0"
    subnet          = ibm_is_subnet.vpc_bastion_subnet.id
    security_groups = [ibm_is_security_group.vpc_sg_bastion.id]
  }

  boot_volume {
    name = "${var.module_var_resource_prefix}-bastion-volume-boot-a"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}


# Create and attach Floating IP on public internet, to the Bastion/Jump Host Virtual Server
# Enables the Internet to initiate a connection directly with the instance

resource "ibm_is_floating_ip" "bastion_floating_ip" {
  name           = "${var.module_var_resource_prefix}-bastion-floating-ip1"
  target         = ibm_is_instance.bastion_host.primary_network_interface[0].id
  resource_group = var.module_var_resource_group_id
}


# Change SSH Port on Bastion/Jump Host
#
# If this execution fails part way, then a re-run of the Terraform Template will likely
# fail to connect to Bastion Host with root user over SSH Port 22 because it was already changed

resource "null_resource" "bastion_ssh_configure" {

  depends_on = [
    ibm_is_instance.bastion_host,
    ibm_is_floating_ip.bastion_floating_ip
    ]

  # Virtual Server Private Key apply file permissions
  provisioner "remote-exec" {
    inline = [
      "echo '---- Sleep 60s to ensure bastion host is ready -----' && sleep 60",
      "echo 'Create ${var.module_var_bastion_user} without sudoer'",
      "useradd --create-home ${var.module_var_bastion_user}",
      "mkdir -p /home/${var.module_var_bastion_user}/.ssh",
      "touch /home/${var.module_var_bastion_user}/.ssh/authorized_keys",
      "echo '${var.module_var_bastion_public_ssh_key}' > /home/${var.module_var_bastion_user}/.ssh/authorized_keys",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ]; then chown -R ${var.module_var_bastion_user}:${var.module_var_bastion_user} /home/${var.module_var_bastion_user}/.ssh ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ]; then chown -R ${var.module_var_bastion_user}:users /home/${var.module_var_bastion_user}/.ssh ; fi",
      "chmod 700 /home/${var.module_var_bastion_user}/.ssh",
      "chmod 600 /home/${var.module_var_bastion_user}/.ssh/authorized_keys",
      "echo '${var.module_var_bastion_user} is created'",
      "echo 'Installing firewalld'",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] ; then echo 'RHEL detected, yum install firewalld' && yum --assumeyes --debuglevel=1 install firewalld ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] ; then echo 'SLES detected, zypper install --no-confirm firewalld' && zypper install --no-confirm firewalld ; fi",
      "echo 'Activate firewalld'",
      "systemctl start firewalld",
      "systemctl enable firewalld",
      "echo 'Changing SSH Port to within IANA Dynamic Ports range'",
      "sed -i 's/#Port 22/Port ${var.module_var_bastion_ssh_port}/' /etc/ssh/sshd_config",
      "if [ $(getenforce) = 'Enforcing' ]; then echo 'SELinux status as enforcing/enabled detected, inform SELinux about port change' && semanage port -a -t ssh_port_t -p tcp ${var.module_var_bastion_ssh_port}; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"8') ]; then echo 'RHEL 8.x detected, adding port to firewall-cmd' && firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp && firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp --permanent ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"8') ]; then echo 'RHEL 8.x detected, amending /etc/ssh/ssh_config to permit AllowTcpForwarding' && sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"15') ]; then echo 'SLES 15.x detected, adding port to firewall-cmd' && firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp && firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp --permanent ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"15') ]; then echo 'SLES 15.x detected, amending /etc/ssh/ssh_config to permit AllowTcpForwarding' && sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config ; fi",
      "echo 'Removing Root SSH Login for Bastion from Public IP'",
      "sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config",
      "echo 'Allowing only Root SSH Login for Bastion from Private IP range of the VPC Subnet (i.e. login to root on Bastion from Virtual Servers only)'",
      "echo 'Match Address ${data.ibm_is_subnet.vpc_subnet.ipv4_cidr_block}' >> /etc/ssh/sshd_config",
      "echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config",
      "echo 'Reload sshd service after sshd_config changes'",
      "systemctl restart sshd",
      "echo 'SSH Port now listening on...'",
      "netstat -tlpn | grep ssh || echo 'netstat not found, ignoring command'" // Use else command to avoid Terraform breaking error "executing "/tmp/terraform_xxxxxxxxxx.sh": Process exited with status 1". REPLACE WITH: ss -tunlp | grep ssh
    ]
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = var.module_var_bastion_private_ssh_key
    host        = ibm_is_floating_ip.bastion_floating_ip.address

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/root/terraform_tmp_remote_exec_inline.sh"
  }

}
