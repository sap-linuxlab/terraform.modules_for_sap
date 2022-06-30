
# Create Bastion/Jump host

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.bastion_os_image.image_id
  instance_type               = "c4.xlarge"
  key_name                    = var.module_var_bastion_ssh_key_name
  vpc_security_group_ids      = [aws_security_group.bastion_connection_sg.id, aws_security_group.bastion_sg.id]
  subnet_id                   = aws_subnet.vpc_bastion_subnet.id
  tenancy                     = "default"
  associate_public_ip_address = "true"

  # Pass cloud-init or bash script payloads with user_data
  # Stored into /var/lib/cloud/instance/user-data.txt
  # Scripts entered as user data are executed as the root user
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
  # user_data = ""

  # Change Hostname, use EOF with dash to trim whitespace
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
  # https://stackoverflow.com/questions/603351/can-we-set-easy-to-remember-hostnames-for-ec2-instances
  # https://github.com/brikis98/terraform-up-and-running-code/issues/12#issuecomment-294375284

  user_data = <<-EOF
   #! /bin/bash
   sudo hostnamectl set-hostname ${var.module_var_resource_prefix}-bastion
 EOF

  root_block_device {
    delete_on_termination = "true"
    volume_size           = "50"
    volume_type           = "standard"
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-bastion"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}



# Change SSH Port on Bastion/Jump Host
#
# If this execution fails part way, then a re-run of the Terraform Template will likely
# fail to connect to Bastion Host with root user over SSH Port 22 because it was already changed

resource "null_resource" "bastion_ssh_configure" {

  depends_on = [
    aws_instance.bastion_host,
    aws_route_table_association.vpc_bastion_rt_associate
  ]

  # Host Private Key apply file permissions
  provisioner "remote-exec" {
    inline = [
      "echo 'Create ${var.module_var_bastion_user} without sudoer'",
      "sudo su - root -c 'useradd --create-home ${var.module_var_bastion_user}'",
      "sudo su - root -c 'mkdir -p /home/${var.module_var_bastion_user}/.ssh'",
      "sudo su - root -c 'touch /home/${var.module_var_bastion_user}/.ssh/authorized_keys'",
      "sudo su - root -c 'echo \"${var.module_var_bastion_public_ssh_key}\" > /home/${var.module_var_bastion_user}/.ssh/authorized_keys'",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] ; then sudo su - root -c 'chown -R ${var.module_var_bastion_user}:${var.module_var_bastion_user} /home/${var.module_var_bastion_user}/.ssh' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] ; then sudo su - root -c 'chown -R ${var.module_var_bastion_user}:users /home/${var.module_var_bastion_user}/.ssh' ; fi",
      "sudo su - root -c 'chmod 700 /home/${var.module_var_bastion_user}/.ssh'",
      "sudo su - root -c 'chmod 600 /home/${var.module_var_bastion_user}/.ssh/authorized_keys'",
      "echo '${var.module_var_bastion_user} is created'",
      "echo 'Installing firewalld'",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] ; then echo 'RHEL detected, yum install firewalld' && yum --assumeyes --debuglevel=1 install firewalld ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] ; then echo 'SLES detected, zypper install --no-confirm firewalld' && zypper install --no-confirm firewalld ; fi",
      "echo 'Activate firewalld'",
      "sudo su - root -c 'systemctl start firewalld'",
      "sudo su - root -c 'systemctl enable firewalld'",
      "echo 'Changing SSH Port to within IANA Dynamic Ports range'",
      "sudo su - root -c 'sed -i \"s/#Port 22/Port ${var.module_var_bastion_ssh_port}/\" /etc/ssh/sshd_config'",
      "if [ $(getenforce) = 'Enforcing' ]; then echo 'SELinux status as enforcing/enabled detected, inform SELinux about port change' && sudo su - root -c 'semanage port -a -t ssh_port_t -p tcp ${var.module_var_bastion_ssh_port}'; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"8') ]; then echo 'RHEL 8.x detected, adding port to firewall-cmd' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp --permanent' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"8') ]; then echo 'RHEL 8.x detected, amending /etc/ssh/ssh_config to permit AllowTcpForwarding' && sudo su - root -c 'sed -i \"s/#AllowTcpForwarding yes/AllowTcpForwarding yes/\" /etc/ssh/sshd_config' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"15') ]; then echo 'SLES 15.x detected, adding port to firewall-cmd' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp' && sudo su - root -c 'firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp --permanent' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '=\"15') ]; then echo 'SLES 15.x detected, amending /etc/ssh/ssh_config to permit AllowTcpForwarding' && sudo su - root -c 'sed -i \"s/#AllowTcpForwarding yes/AllowTcpForwarding yes/\" /etc/ssh/sshd_config' ; fi",
      "echo 'Removing Root SSH Login for Bastion from Public IP'",
      "sudo su - root -c 'sed -i \"s/PermitRootLogin yes/PermitRootLogin no/\" /etc/ssh/sshd_config'",
      "echo 'Allowing only Root SSH Login for Bastion from Private IP range of the VPC Subnet (i.e. login to root on Bastion from Host/s only)'",
      "sudo su - root -c 'echo \"Match Address ${data.aws_subnet.vpc_subnet.cidr_block}\" >> /etc/ssh/sshd_config'",
      "sudo su - root -c 'echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config'",
      "echo 'Reload sshd service after sshd_config changes'",
      "sudo su - root -c 'systemctl restart sshd'",
      "echo 'SSH Port now listening on...'",
      "sudo su - root -c 'netstat -tlpn | grep ssh' || echo 'netstat not found, ignoring command'", // Use else command to avoid Terraform breaking error "executing "/tmp/terraform_xxxxxxxxxx.sh": Process exited with status 1". REPLACE WITH: ss -tunlp | grep ssh
      "echo 'Disable ec2-user'",
      "sudo mv /home/ec2-user/.ssh/authorized_keys /home/ec2-user/.ssh/disabled_keys",
      "echo 'Disabled the ec2-user'"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.module_var_bastion_private_ssh_key
    host        = aws_instance.bastion_host.public_ip

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/home/ec2-user/terraform_tmp_remote_exec_inline.sh"
  }

}
