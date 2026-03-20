# Note: If login uses root, you do not need "sudo" prefix or "sudo su - root -c 'command here'"
#       For AWS, MS Azure and GCP without initial root login the sudo elevated privilege is required

# Change SSH Port on Bastion/Jump Host
#
# If this execution fails part way, then a re-run of the Terraform Template will likely
# fail to connect to Bastion Host with root user over SSH Port 22 because it was already changed

resource "null_resource" "bastion_config_1" {

  depends_on = [
    aws_instance.bastion_host,
    aws_route_table_association.vpc_bastion_rt_associate
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.module_var_bastion_private_ssh_key
    host        = aws_instance.bastion_host.public_ip

    # Required when using RHEL 8.x because /tmp is set with noexec
    # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
    # https://www.terraform.io/language/resources/provisioners/connection#executing-scripts-using-ssh-scp
    # script_path = "/home/azvm-user/terraform_tmp_remote_exec_inline.sh"
  }

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "bastion_config_1.sh"
    content     = <<EOT
    #!/bin/bash
    echo '---- Sleep 60s to ensure bastion host is ready after initial boot and cloud-init -----' && sleep 60",

    os_release=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
    os_version=$(grep ^VERSION_ID= /etc/os-release)

    # firewalld as default (available since RHEL 7 or SLES 15 SP3)
    # or directly use either nftables or iptables (legacy)
    os_network_security_method="firewalld"


    echo 'Create ${var.module_var_bastion_user} without sudoer'
    useradd --create-home ${var.module_var_bastion_user}
    mkdir -p /home/${var.module_var_bastion_user}/.ssh

    /bin/cp -f /home/ec2-user/.ssh/authorized_keys /home/${var.module_var_bastion_user}/.ssh/authorized_keys
    if [ "$os_release" = 'rhel' ]; then chown -R ${var.module_var_bastion_user}:${var.module_var_bastion_user} /home/${var.module_var_bastion_user}/.ssh ; fi
    if [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ]; then chown -R ${var.module_var_bastion_user}:users /home/${var.module_var_bastion_user}/.ssh ; fi
    chmod 750 /home/${var.module_var_bastion_user}/.ssh
    chmod 600 /home/${var.module_var_bastion_user}/.ssh/authorized_keys
    echo '${var.module_var_bastion_user} is created'

    if [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ]; then echo 'Creating sshd_config override file' && mkdir -p /etc/ssh && cp /usr/etc/ssh/sshd_config /etc/ssh/sshd_config ; fi

    echo 'Changing SSH Port to within IANA Dynamic Ports range'
    sed -i 's/#Port 22/Port ${var.module_var_bastion_ssh_port}/' /etc/ssh/sshd_config

    echo 'Enable SSH AllowTcpForwarding'
    sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config

    echo 'Removing Root SSH Login for Bastion from Public IP'
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
    echo 'Allow SSH Login to root user only from the Bastion private Subnet range (i.e. no root login using Public IP)'
    echo 'Match Address ${data.aws_subnet.vpc_subnet.cidr_block}' >> /etc/ssh/sshd_config
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

    echo 'Reload sshd service after sshd_config changes'
    systemctl restart sshd

    echo 'SSH Port now listening on...'
    # Use else command to avoid Terraform breaking error "executing "/tmp/terraform_xxxxxxxxxx.sh": Process exited with status 1". REPLACE WITH: ss -tunlp | grep ssh
    if [ "$os_release" = 'rhel' ]; then yum --assumeyes --debuglevel=1 install net-tools ; fi
    if [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ]; then zypper install --no-confirm net-tools ; fi
    netstat -tlpn | grep ssh || echo 'netstat not found, ignoring command'
    sshd -T | grep port

    echo 'Amending SELinux if present'
    if [ $(getenforce) = 'Enforcing' ]; then echo 'SELinux status as enforcing/enabled detected, inform SELinux about port change' && semanage port -a -t ssh_port_t -p tcp ${var.module_var_bastion_ssh_port}; fi


    if [ "$os_network_security_method" = 'firewalld' ]; then
      if [ "$os_release" = 'rhel' ]; then
        dnf --assumeyes --debuglevel=1 install firewalld
      elif [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ]; then
        zypper install --no-confirm firewalld
      fi
      echo 'Activate firewalld'
      systemctl start firewalld
      systemctl enable firewalld

      echo 'Allow new SSH Port'
      firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" port port="${var.module_var_bastion_ssh_port}" protocol="tcp" log prefix="[ALLOW_SSH_CUSTOM]" accept'
      # firewall-cmd --permanent --add-port ${var.module_var_bastion_ssh_port}/tcp

      # Cannot append rules with prerouting in firewalld so use rich rules
      # Use drop for silent, instead of reject
      firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" port port=22 protocol=tcp log prefix="[DROP_SSH_22]" drop'
      firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" port port=22 protocol=udp log prefix="[DROP_SSH_22]" drop'

      firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" family="ipv4" icmp-type name="echo-request" log prefix="[DROP_ICMP_PING]" drop'
      firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" family="ipv4" icmp-type name="echo-reply" log prefix="[DROP_ICMP_PING]" drop'

      firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" family="ipv6" icmp-type name="echo-request" log prefix="[DROP_ICMPV6_PING]" drop'
      firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" family="ipv6" icmp-type name="echo-reply" log prefix="[DROP_ICMPV6_PING]" drop'

      firewall-cmd --reload
    fi

    if [ "$os_network_security_method" = 'iptables' ]; then
      echo 'Use legacy iptables'
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

    if [ "$os_network_security_method" = 'nftables' ]; then
      echo 'Ensure firewalld is disabled (nftables (Netfilter service is auto disabled when firewalld enabled)'
      systemctl stop firewalld
      systemctl disable firewalld
      systemctl mask firewalld

      echo 'Ensure nftables installed, and install'
      if [ "$os_release" = 'rhel' ]; then
        dnf --assumeyes --debuglevel=1 install nftables
      elif [ "$os_release" = 'sles' ] || [ "$os_release" = 'sles_sap' ]; then
        zypper install --no-confirm nftables
      fi

      systemctl start nftables
      systemctl enable nftables
      # Checking status will cause Terraform session to break, so grep active line to confirm running
      systemctl status nftables | grep "Loaded:"
      systemctl status nftables | grep "Active:"

      echo 'Create Table with family as "inet" (for both ip and ip6 families)'
      nft add table inet ssh_drop_table

      echo 'Create Table Chain with type as "filter" and hook as "prerouting" (for inet, hooks are prerouting,input,forward,output,postrouting,ingress)'
      nft add chain inet ssh_drop_table ssh_drop_filter_chain '{ type filter hook prerouting priority 0 ; }'

      # Use background (& suffix) to avoid lock-out of current script
      echo 'Create Rule inside Table Chain (add to end of chain, or insert to top of chain)'
      nft add rule inet ssh_drop_table ssh_drop_filter_chain icmp type { echo-request, echo-reply } log prefix \"[nftables_SSHDROP] \" drop
      nft add rule inet ssh_drop_table ssh_drop_filter_chain icmpv6 type { echo-request, echo-reply } log prefix \"[nftables_SSHDROP] \" drop
      nohup bash -c 'sleep 5; nft add rule inet ssh_drop_table ssh_drop_filter_chain tcp dport 22 log prefix \"[nftables_SSHDROP] \" drop' &>/dev/null & disown
      nohup bash -c 'sleep 5; nft add rule inet ssh_drop_table ssh_drop_filter_chain udp dport 22 log prefix \"[nftables_SSHDROP] \" drop' &>/dev/null & disown

      # Show tables
      # nft list ruleset
    fi

  echo 'Disable password expiry for Bastion user with change age (chage)'
  # this is to avoid 'Your password has expired' after 60+ days
  chage -m 0 -M 99999 -I -1 -E -1 ${var.module_var_bastion_user}

  EOT
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/bastion_config_1.sh ; sudo su - root -c 'bash /home/ec2-user/bastion_config_1.sh'"
    ]
  }

}
