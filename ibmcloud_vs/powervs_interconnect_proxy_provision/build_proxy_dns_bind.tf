
### Proxy for DNS Resolver not required for IBM Power Workspaces that use backend Power Edge Router (PER)


# resource "null_resource" "bind_files" {

#   count = var.module_var_proxy_enabled_bind ? 1 : 0

#   depends_on = [ibm_dns_resource_record.dns_resource_record_a]

#   # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
#   # https://www.terraform.io/language/resources/provisioners/file#destination-paths
#   provisioner "file" {
#     destination = "/tmp/named.conf"
#     content     = <<EOF
# //
# // named.conf
# //
# // Provided by Red Hat bind package to configure the ISC BIND named(8) DNS
# // server as a caching only nameserver (as a localhost DNS resolver only).
# //
# // See /usr/share/doc/bind*/sample/ for example named configuration files.
# //
# // See the BIND Administrator's Reference Manual (ARM) for details about the
# // configuration located in /usr/share/doc/bind-{version}/Bv9ARM.html

# options {
# 	listen-on port 53 { 127.0.0.1; ${ibm_is_instance.proxy_virtual_server.primary_network_attachment[0].virtual_network_interface[0].primary_ip[0].address}; };
# 	listen-on-v6 port 53 { ::1; };
# 	directory 	"/var/named";
# 	dump-file 	"/var/named/data/cache_dump.db";
# 	statistics-file "/var/named/data/named_stats.txt";
# 	memstatistics-file "/var/named/data/named_mem_stats.txt";
# 	recursing-file  "/var/named/data/named.recursing";
# 	secroots-file   "/var/named/data/named.secroots";
# 	allow-query     { localhost; 10.0.0.0/8; 172.16.0.0/12; 192.168.0.0/16;};

# 	/* 
# 	 - If you are building an AUTHORITATIVE DNS server, do NOT enable recursion.
# 	 - If you are building a RECURSIVE (caching) DNS server, you need to enable 
# 	   recursion. 
# 	 - If your recursive DNS server has a public IP address, you MUST enable access 
# 	   control to limit queries to your legitimate users. Failing to do so will
# 	   cause your server to become part of large scale DNS amplification 
# 	   attacks. Implementing BCP38 within your network would greatly
# 	   reduce such attack surface 
# 	*/
# /*
# 	recursion yes;
# 	dnssec-enable yes;
# 	dnssec-validation yes;
#  */
# 	/* Path to ISC DLV key */
# /*
# 	bindkeys-file "/etc/named.root.key";

# 	managed-keys-directory "/var/named/dynamic";
# 	pid-file "/run/named/named.pid";
# 	session-keyfile "/run/named/session.key";
# */
# };

# logging {
#         channel default_debug {
#                 file "data/named.run";
#                 severity dynamic;
#         };
# };

# zone "." IN {
# 	type forward;
# 	forward only;
# 	forwarders { 161.26.0.7; 161.26.0.8; 8.8.8.8; 1.1.1.1; };
# };

# /*
# include "/etc/named.rfc1912.zones";
# include "/etc/named.root.key";
# */
# EOF
#   }


#   # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
#   # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
#   # https://www.terraform.io/language/resources/provisioners/file#destination-paths
#   provisioner "file" {
#     destination = "terraform_proxy_dns_bind.sh"
#     content     = <<EOF
# #!/bin/bash

# # Verify OS distribution
# export os_type=""
# export os_version=""

# os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
# os_info_version=$(grep ^VERSION_ID= /etc/os-release | awk -F '=' '{print $2}' | tr -d '\"')

# if [ "$os_info_id" = "sles" ] || [ "$os_info_id" = "sles_sap" ] ; then os_type="sles"
# elif [ "$os_info_id" = "rhel" ] ; then os_type="rhel" ; fi
# os_version=$os_info_version

# echo "Detected $os_type Linux Operating System Distribution"


# echo 'Install bind and lsof...'
# if [ "$os_type" = "rhel" ] ; then yum --assumeyes --debuglevel=1 install bind lsof ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm bind lsof ; fi

# # Stop
# systemctl stop named

# if [ -f '/etc/named.conf' ]; then mv /etc/named.conf /etc/named.conf.backup ; fi
# mv /tmp/named.conf /etc/
# chmod 644 /etc/named.conf

# # Start
# systemctl start named

# # Checking status will cause Terraform session to break, so grep active line to confirm running
# systemctl status named | grep "Active:"

# # Verify bind is listening
# echo "Verify bind is listening"
# lsof -i TCP:53
# lsof -i UDP:53

# EOF
#   }

#   connection {
#     # The Bastion host ssh connection is established first, and then the host connection will be made from there.
#     # Checking Host Key is false when not using bastion_host_key
#     type         = "ssh"
#     user         = "root"
#     host         = ibm_is_instance.proxy_virtual_server.primary_network_attachment[0].virtual_network_interface[0].primary_ip[0].address
#     private_key  = var.module_var_host_private_ssh_key
#     bastion_host = var.module_var_bastion_floating_ip
#     #bastion_host_key = 
#     bastion_port        = var.module_var_bastion_ssh_port
#     bastion_user        = var.module_var_bastion_user
#     bastion_private_key = var.module_var_bastion_private_ssh_key
#   }

# }
