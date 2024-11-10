
variable "module_var_ibmcloud_vpc_subnet_name" {}

variable "module_var_resource_prefix" {}

variable "module_var_resource_tags" {}

variable "module_var_resource_group_id" {}

variable "module_var_virtual_server_hostname" {}

variable "module_var_dns_root_domain_name" {}

variable "module_var_dns_services_instance" {}

variable "module_var_bastion_connection_security_group_id" {}

variable "module_var_host_security_group_id" {}

variable "module_var_bastion_ssh_port" {}

variable "module_var_bastion_floating_ip" {}

variable "module_var_bastion_private_ssh_key" {
  sensitive = false
}

variable "module_var_bastion_public_ssh_key" {
  sensitive = false
}

variable "module_var_host_ssh_key_id" {}

variable "module_var_host_private_ssh_key" {
  sensitive = false
}

variable "module_var_bastion_user" {}

variable "module_var_virtual_server_profile" {}

variable "module_var_proxy_os_image" {}


# Proxy for DNS Resolver not required for IBM Power Workspaces that use backend Power Edge Router (PER)
# variable "module_var_proxy_enabled_bind" {
#   default = true
# }

variable "module_var_proxy_enabled_squid" {
  default = true
}

variable "module_var_proxy_enabled_nginx" {
  default = false
}

# Proxies created within the IANA Dynamic Ports range (49152 to 65535)"
variable "module_var_proxy_port_squid" {
  default = 50888
}
