
# Create Bastion/Jump Host Virtual Server

resource "ibm_is_instance" "bastion_host" {

  resource_group = var.module_var_resource_group_id
  name           = "${var.module_var_resource_prefix}-bastion"
  profile        = "cx2-4x8"
  vpc            = local.target_vpc_id
  zone           = local.target_vpc_availability_zone
  image          = data.ibm_is_image.bastion_os_image.id // Must use Image ID
  keys           = [var.module_var_bastion_ssh_key_id]

  # The Subnet assigned to the legacy primary Network Interface (vNIC) cannot be changed
  # The Name and Security Group assigned are editable
  # primary_network_interface {
  #   name            = "${var.module_var_resource_prefix}-bastion-nic-0"
  #   subnet          = ibm_is_subnet.vpc_bastion_subnet.id
  #   security_groups = [ibm_is_security_group.vpc_sg_bastion.id]
  # }

  # The Subnet assigned to the primary Virtual Network Interface (VNI) cannot be changed
  # The Name and Security Group assigned are editable
  # Each VNI has a network performance cap of 16 Gbps; this is separate to the network performance cap increment of 2GBps per vCPU
  primary_network_attachment {
    name   = "${var.module_var_resource_prefix}-bastion-vni-0-attach"
    virtual_network_interface {
      name = "${var.module_var_resource_prefix}-bastion-vni-0"
      resource_group = var.module_var_resource_group_id
      subnet = ibm_is_subnet.vpc_bastion_subnet.id
      security_groups = [ibm_is_security_group.vpc_sg_bastion.id]
      allow_ip_spoofing = false
      enable_infrastructure_nat = true // must be true as Virtual Server instances require Infrastructure NAT
      protocol_state_filtering_mode = "auto"
      auto_delete = true // if VNI created separately, must be false
    }
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
  target         = ibm_is_instance.bastion_host.primary_network_attachment[0].virtual_network_interface[0].id
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

  connection {
    type        = "ssh"
    user        = "root"
    private_key = var.module_var_bastion_private_ssh_key
    host        = ibm_is_floating_ip.bastion_floating_ip.address

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    # script_path = "/home/azvm-user/terraform_tmp_remote_exec_inline.sh"
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "bastion_script.sh"
    content     = <<EOT
    #!/bin/bash
    echo '---- Sleep 20s to ensure bastion host is ready -----' && sleep 20

    echo 'Create ${var.module_var_bastion_user} without sudoer'
    useradd --create-home ${var.module_var_bastion_user}
    mkdir -p /home/${var.module_var_bastion_user}/.ssh

    /bin/cp -f /root/.ssh/authorized_keys /home/${var.module_var_bastion_user}/.ssh/authorized_keys
    if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'rhel' ]; then chown -R ${var.module_var_bastion_user}:${var.module_var_bastion_user} /home/${var.module_var_bastion_user}/.ssh ; fi
    if [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles' ] || [ $(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"') = 'sles_sap' ]; then chown -R ${var.module_var_bastion_user}:users /home/${var.module_var_bastion_user}/.ssh ; fi
    chmod 750 /home/${var.module_var_bastion_user}/.ssh
    chmod 600 /home/${var.module_var_bastion_user}/.ssh/authorized_keys
    echo '${var.module_var_bastion_user} is created'

    echo 'Changing SSH Port to within IANA Dynamic Ports range'
    sed -i 's/#Port 22/Port ${var.module_var_bastion_ssh_port}/' /etc/ssh/sshd_config

    echo 'Enable SSH AllowTcpForwarding'
    sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config

    echo 'Removing Root SSH Login for Bastion from Public IP'
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
    echo 'Allow SSH Login to root user only from the Bastion private Subnet range (i.e. no root login using Public IP)'
    echo 'Match Address ${data.ibm_is_subnet.vpc_subnet.ipv4_cidr_block}' >> /etc/ssh/sshd_config
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
      "chmod +x ./bastion_script.sh ; bash ./bastion_script.sh"
    ]
  }

}
