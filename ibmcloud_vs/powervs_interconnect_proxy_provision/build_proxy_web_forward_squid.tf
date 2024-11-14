
resource "null_resource" "squid_files" {

  count = var.module_var_proxy_enabled_squid ? 1 : 0

  depends_on = [ibm_dns_resource_record.dns_resource_record_a]

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "/tmp/squid.conf"
    content     = <<EOF
#
# Recommended minimum configuration:
#

# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing
# should be allowed
acl localnet src 0.0.0.1-0.255.255.255	# RFC 1122 "this" network (LAN)
acl localnet src 10.0.0.0/8             # RFC 1918 local private network (LAN)
acl localnet src 172.16.0.0/12          # RFC 1918 local private network (LAN)
acl localnet src 192.168.0.0/16         # RFC 1918 local private network (LAN)
acl localnet src fc00::/7               # RFC 4193 local private network range
acl localnet src 169.254.0.0/16 	      # RFC 3927 link-local (directly plugged) machines
acl localnet src fe80::/10              # RFC 4291 link-local (directly plugged) machines
acl localnet src 100.64.0.0/10		      # RFC 6598 shared address space (CGN)
acl localnet src all

acl FTP_ports port 21 20
acl SSL_ports port 443          # ssl
acl SSL_ports port 8443         # ssl (os package mirrors)
acl Safe_ports port 22          # ssh
acl Safe_ports port 80          # http
acl Safe_ports port 443         # https
acl Safe_ports port 8443        # https alt
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
#acl Safe_ports port 1025-65535  # unregistered ports
acl CONNECT method CONNECT

#
# Recommended minimum Access Permission configuration:
#

# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager

# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost

#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
http_access allow localhost

# And finally deny all other access to this proxy
#http_access deny all

# OVERRIDE: public internet forward proxy for HTTP/HTTPS
#http_access allow all

# Squid normally listens to port 3128
http_port ${var.module_var_proxy_port_squid}

# Uncomment and adjust the following to add a disk cache directory.
#cache_dir ufs /var/spool/squid 100 16 256

# Leave coredumps in the first cache dir
coredump_dir /var/spool/squid

#
# Add any of your own refresh_pattern entries above these.
#
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320

EOF
  }


  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_proxy_web_squid.sh"
    content     = <<EOF
#!/bin/bash

# Verify OS distribution
export os_type=""
export os_version=""

os_info_id=$(grep ^ID= /etc/os-release | cut -d '=' -f2 | tr -d '\"')
os_info_version=$(grep ^VERSION_ID= /etc/os-release | awk -F '=' '{print $2}' | tr -d '\"')

if [ "$os_info_id" = "sles" ] || [ "$os_info_id" = "sles_sap" ] ; then os_type="sles"
elif [ "$os_info_id" = "rhel" ] ; then os_type="rhel" ; fi
os_version=$os_info_version

echo "Detected $os_type Linux Operating System Distribution"


echo 'Install squid and lsof...'
if [ "$os_type" = "rhel" ] ; then yum --assumeyes --debuglevel=1 install squid lsof ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm squid lsof ; fi

# Move squid config file
mv /etc/squid/squid.conf /etc/squid/squid.conf.install.backup
mv /tmp/squid.conf /etc/squid/squid.conf

# Restart squid
systemctl stop squid
systemctl restart squid
#sleep 3; squid

# Checking status will cause Terraform session to break, so grep active line to confirm running
systemctl status squid | grep "Active:"

# Verify squid is listening
echo "Verify squid is listening"
lsof -i TCP:${var.module_var_proxy_port_squid}

EOF
  }

  connection {
    # The Bastion host ssh connection is established first, and then the host connection will be made from there.
    # Checking Host Key is false when not using bastion_host_key
    type         = "ssh"
    user         = "root"
    host         = ibm_is_instance.proxy_virtual_server.primary_network_attachment[0].virtual_network_interface[0].primary_ip[0].address
    private_key  = var.module_var_host_private_ssh_key
    bastion_host = var.module_var_bastion_floating_ip
    #bastion_host_key = 
    bastion_port        = var.module_var_bastion_ssh_port
    bastion_user        = var.module_var_bastion_user
    bastion_private_key = var.module_var_bastion_private_ssh_key
  }

}
