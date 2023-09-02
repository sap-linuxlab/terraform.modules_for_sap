
# Create Bastion/Jump host

resource "google_compute_instance" "bastion_host" {
  name         = "${var.module_var_resource_prefix}-bastion"
  machine_type = "e2-standard-2"
  zone         = var.module_var_gcp_region_zone

  boot_disk {
    auto_delete = true
    device_name = "${var.module_var_resource_prefix}-bastion-volume-boot"
    initialize_params {
      image = data.google_compute_image.bastion_os_image.self_link
      size  = 100
    }
  }

  network_interface {
#    name       = "${var.module_var_resource_prefix}-bastion-nic0"
    subnetwork = google_compute_subnetwork.vpc_bastion_subnet.id
    nic_type   = "VIRTIO_NET" // Must use virtIO KVM NIC driver, Google Virtual NIC driver has unknown support for SAP workloads
    stack_type = "IPV4_ONLY"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = false // Do not use GCP Project OS Login approach for SSH Keys
    block-project-ssh-keys = true // Do not use GCP Project Metadata approach for SSH Keys
    ssh-keys = "${var.module_var_bastion_user}:${var.module_var_bastion_public_ssh_key}" // Uses the GCP VM Instance Metadata approach for SSH Keys. Shows in GCP Console GUI under 'SSH Keys' for the VM Instance. Can not use 'root' because SSH 'PermitRootLogin' by default is 'no'.
  }

}



# Change SSH Port on Bastion/Jump Host
#
# If this execution fails part way, then a re-run of the Terraform Template will likely
# fail to connect to Bastion Host with root user over SSH Port 22 because it was already changed

resource "null_resource" "bastion_ssh_configure" {

  depends_on = [
    google_compute_instance.bastion_host
  ]

  # Host Private Key apply file permissions
  provisioner "remote-exec" {
    inline = [
      "echo 'Set hostname'",
      "sudo hostnamectl set-hostname ${var.module_var_resource_prefix}-bastion",
      "echo 'Installing firewalld'",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] ; then echo 'RHEL detected, yum install firewalld' && sudo su - root -c 'yum --disablerepo=*source* --disablerepo=*debug* --disablerepo=*google* --assumeyes --debuglevel=1 install firewalld' ; fi",
      "if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] ; then echo 'SLES detected, zypper install --no-confirm firewalld' && sudo su - root -c 'zypper install --no-confirm firewalld' ; fi",
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
      "sudo su - root -c 'echo \"Match Address ${local.target_vpc_subnet_range}\" >> /etc/ssh/sshd_config'",
      "sudo su - root -c 'echo \"PermitRootLogin yes\" >> /etc/ssh/sshd_config'",
      "echo 'Reload sshd service after sshd_config changes'",
      "sudo su - root -c 'systemctl restart sshd'",
      "echo 'SSH Port now listening on...'",
      "sudo su - root -c 'netstat -tlpn | grep ssh' || echo 'netstat not found, ignoring command'" // Use else command to avoid Terraform breaking error "executing "/tmp/terraform_xxxxxxxxxx.sh": Process exited with status 1". REPLACE WITH: ss -tunlp | grep ssh
    ]
  }

  connection {
    type        = "ssh"
    user        = var.module_var_bastion_user
    private_key = var.module_var_bastion_private_ssh_key
    host        = google_compute_instance.bastion_host.network_interface[0].access_config[0].nat_ip

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    script_path = "/home/${var.module_var_bastion_user}/terraform_tmp_remote_exec_inline.sh"
  }

}
