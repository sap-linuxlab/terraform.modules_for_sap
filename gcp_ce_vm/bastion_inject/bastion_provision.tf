
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

  connection {
    type        = "ssh"
    user        = var.module_var_bastion_user
    private_key = var.module_var_bastion_private_ssh_key
    host        = google_compute_instance.bastion_host.network_interface[0].access_config[0].nat_ip

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    # script_path = "/home/${var.module_var_bastion_user}/terraform_tmp_remote_exec_inline.sh"
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "bastion_script.sh"
    content     = <<EOT
    #!/bin/bash
    echo '---- Sleep 20s to ensure bastion host is ready -----' && sleep 20

    echo 'Set hostname'
    hostnamectl set-hostname ${var.module_var_resource_prefix}-bastion

    echo 'Changing SSH Port to within IANA Dynamic Ports range'
    sed -i 's/#Port 22/Port ${var.module_var_bastion_ssh_port}/' /etc/ssh/sshd_config

    echo 'Enable SSH AllowTcpForwarding'
    sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config

    echo 'Removing Root SSH Login for Bastion from Public IP'
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
    echo 'Allow SSH Login to root user only from the Bastion private Subnet range (i.e. no root login using Public IP)'
    echo 'Match Address ${local.target_vpc_subnet_range}' >> /etc/ssh/sshd_config
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

    echo 'Reload sshd service after sshd_config changes'
    systemctl restart sshd

    echo 'SSH Port now listening on...'
    # Use else command to avoid Terraform breaking error "executing "/tmp/terraform_xxxxxxxxxx.sh": Process exited with status 1". REPLACE WITH: ss -tunlp | grep ssh
    if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ]; then yum --assumeyes --debuglevel=1 install net-tools ; fi
    if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ]; then zypper install --no-confirm net-tools ; fi
    netstat -tlpn | grep ssh || echo 'netstat not found, ignoring command'

    echo 'Amending SELinux if present'
    if [ $(getenforce) = 'Enforcing' ]; then echo 'SELinux status as enforcing/enabled detected, inform SELinux about port change' && semanage port -a -t ssh_port_t -p tcp ${var.module_var_bastion_ssh_port}; fi

    if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '="7') ]; then
      echo 'RHEL 7.x detected, use firewalld and iptables'
      echo 'RHEL detected, yum install firewalld'
      yum --assumeyes --debuglevel=1 install firewalld
      echo 'Activate firewalld'
      systemctl start firewalld
      systemctl enable firewalld
      echo 'Allow new SSH Port'
      firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp
      firewall-cmd --add-port ${var.module_var_bastion_ssh_port}/tcp --permanent
      firewall-cmd --reload
      # Detection of Primary Network Interface
      # Find network adapter - identify the adapter, by showing which is used for the Default Gateway route
      # If statement to catch RHEL installations with route table multiple default entries
      # https://serverfault.com/questions/47915/how-do-i-get-the-default-gateway-in-linux-given-the-destination
      ACTIVE_NETWORK_ADAPTER=$(ip route show default 0.0.0.0/0 | awk '/default/ && !/metric/ {print $5}')
      CURRENT_IP=$(ip -oneline address show $ACTIVE_NETWORK_ADAPTER | sed -n 's/.*inet \(.*\)\/.*/\1/p')
      # Drop SSH Port 22 and ICMP Ping connection attempts
      # Append rule to iptables chain
      iptables --append INPUT --protocol tcp --dport 22 --in-interface $ACTIVE_NETWORK_ADAPTER --destination $CURRENT_IP --jump DROP
      iptables --append INPUT --protocol udp --dport 22 --in-interface $ACTIVE_NETWORK_ADAPTER --destination $CURRENT_IP --jump DROP
      iptables --append INPUT --protocol icmp --icmp-type echo-request --in-interface $ACTIVE_NETWORK_ADAPTER --destination $CURRENT_IP --jump DROP
    fi

    if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '="8\|="9') ]; then
      echo 'RHEL 8.x/9.x detected, use nftables'
      echo 'Ensure firewalld is disabled (nftables (Netfilter service is auto disabled when firewalld enabled)'
      systemctl stop firewalld
      systemctl disable firewalld
      systemctl mask firewalld

      echo 'Ensure nftables installed, and install'
      yum --assumeyes --debuglevel=1 install nftables
      systemctl start nftables
      systemctl enable nftables
      # Checking status will cause Terraform session to break, so grep active line to confirm running
      sudo systemctl status nftables | grep "Loaded:"
      sudo systemctl status nftables | grep "Active:"

      echo 'Create Table with family as "inet" (for both ip and ip6 families)'
      nft add table inet ssh_drop_table

      echo 'Create Table Chain with type as "filter" and hook as "prerouting" (for inet, hooks are prerouting,input,forward,output,postrouting,ingress)'
      nft add chain inet ssh_drop_table ssh_drop_filter_chain { type filter hook prerouting priority 0 \; }

      # Use background (& suffix) to avoid lock-out of current script
      echo 'Create Rule inside Table Chain (add to end of chain, or insert to top of chain)'
      nft add rule inet ssh_drop_table ssh_drop_filter_chain icmp type { echo-request, echo-reply } log prefix \"[iptables_SSHDROP] \" drop
      nft add rule inet ssh_drop_table ssh_drop_filter_chain icmpv6 type { echo-request, echo-reply } log prefix \"[iptables_SSHDROP] \" drop
      nohup bash -c 'sleep 5; nft add rule inet ssh_drop_table ssh_drop_filter_chain tcp dport 22 log prefix \"[iptables_SSHDROP] \" drop' &>/dev/null & disown
      nohup bash -c 'sleep 5; nft add rule inet ssh_drop_table ssh_drop_filter_chain udp dport 22 log prefix \"[iptables_SSHDROP] \" drop' &>/dev/null & disown

      # Show tables
      # nft list ruleset
    fi

    if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ] && [ $(grep ^VERSION_ID= /etc/os-release | grep '="15') ]; then
      echo 'SLES 15.x detected, use nftables'
      echo 'Ensure firewalld is disabled (nftables (Netfilter service is auto disabled when firewalld enabled)'
      systemctl stop firewalld
      systemctl disable firewalld
      systemctl mask firewalld

      echo 'Ensure nftables installed, and install'
      zypper install --no-confirm nftables
      systemctl start nftables
      systemctl enable nftables
      # Checking status will cause Terraform session to break, so grep active line to confirm running
      sudo systemctl status nftables | grep "Loaded:"
      sudo systemctl status nftables | grep "Active:"

      echo 'Create Table with family as "inet" (for both ip and ip6 families)'
      nft add table inet ssh_drop_table

      echo 'Create Table Chain with type as "filter" and hook as "prerouting" (for inet, hooks are prerouting,input,forward,output,postrouting,ingress)'
      nft add chain inet ssh_drop_table ssh_drop_filter_chain { type filter hook prerouting priority 0 \; }

      # Use background (& suffix) to avoid lock-out of current script
      echo 'Create Rule inside Table Chain (add to end of chain, or insert to top of chain)'
      nft add rule inet ssh_drop_table ssh_drop_filter_chain icmp type { echo-request, echo-reply } log prefix \"[iptables_SSHDROP] \" drop
      nft add rule inet ssh_drop_table ssh_drop_filter_chain icmpv6 type { echo-request, echo-reply } log prefix \"[iptables_SSHDROP] \" drop
      nohup bash -c 'sleep 5; nft add rule inet ssh_drop_table ssh_drop_filter_chain tcp dport 22 log prefix \"[iptables_SSHDROP] \" drop' &>/dev/null & disown
      nohup bash -c 'sleep 5; nft add rule inet ssh_drop_table ssh_drop_filter_chain udp dport 22 log prefix \"[iptables_SSHDROP] \" drop' &>/dev/null & disown

      # Show tables
      # nft list ruleset
    fi

  EOT
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ./bastion_script.sh ; sudo su - root -c 'bash ./bastion_script.sh'"
    ]
  }

}
