
resource "null_resource" "nginx_files" {

  count = var.module_var_proxy_enabled_nginx ? 1 : 0

  depends_on = [ibm_dns_resource_record.dns_resource_record_a]

  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/terraform/tmp/
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "/tmp/nginx.conf"
    content     = <<EOF
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;


# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
### mod-http-image-filter.conf
### mod-http-perl.conf
### mod-http-xslt-filter.conf
### mod-mail.conf
### mod-stream.conf
#include /usr/share/nginx/modules/*.conf;


events {
    worker_connections 1024;
}


http {

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;


    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    #include /etc/nginx/conf.d/*.conf;

    #gzip  on;

    proxy_http_version 1.1;
    proxy_buffering off;
    proxy_intercept_errors on;


    # HTTP (:80)
    server {
        listen       80 default_server;
        listen       [::]:80 default_server;

        server_name  _;
#        server_name  localhost;

        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        #include /etc/nginx/default.d/*.conf;

        location / {
        }

        # redirect 404 server error pages to the static page /40x.html
        error_page 404 /404.html;
            location = /40x.html {
        }

        # redirect 50x server error pages to the static page /50x.html
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root   html;
        }

    }


    # HTTPS (:443) server / TLS enabled server
    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;

        server_name  _;
#        server_name  localhost;

        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        #include /etc/nginx/default.d/*.conf;

#        ssl_certificate    "/etc/pki/tls/certs/cert.pem";
#        ssl_certificate    "/etc/pki/nginx/server.crt";

#        ssl_certificate_key    "/etc/pki/tls/private/cert.key";
#        ssl_certificate_key    "/etc/pki/nginx/private/server.key";

#        ssl_session_cache    shared:SSL:1m;
#        ssl_session_timeout     10m;

#        ssl_prefer_server_ciphers   on;

#        ssl_ciphers    HIGH:!aNULL:!MD5;
#        ssl_ciphers    PROFILE=SYSTEM;

        location / {
        }

        # redirect 404 server error pages to the static page /40x.html
        error_page 404 /404.html;
            location = /40x.html {
        }

        # redirect 50x server error pages to the static page /50x.html
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root   html;
        }

    }

}

EOF
  }


  # Path must already exist and must not use Bash shell special variable, e.g. cannot use $HOME/file.sh
  # "By default, OpenSSH's scp implementation runs in the remote user's home directory and so you can specify a relative path to upload into that home directory"
  # https://www.terraform.io/language/resources/provisioners/file#destination-paths
  provisioner "file" {
    destination = "terraform_proxy_web_nginx.sh"
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


echo 'Install nginx and lsof...'
if [ "$os_type" = "rhel" ] ; then yum --assumeyes --debuglevel=1 install nginx lsof ; elif [ "$os_type" = "sles" ] ; then zypper install --no-confirm nginx lsof ; fi
#yum install easy-rsa

# Move nginx config file
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.install.backup
mv /tmp/nginx.conf /etc/nginx/nginx.conf

# Verify configuration file
nginx -t

# Send a signal to the master process as quit (SIGQUIT), then start nginx
nginx -s quit
systemctl restart nginx
#sleep 3; nginx

# Checking status will cause Terraform session to break, so grep active line to confirm running
systemctl status nginx | grep "Active:"

# Verify nginx is listening
echo "Verify nginx is listening"
lsof -i TCP:80
lsof -i TCP:443

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
