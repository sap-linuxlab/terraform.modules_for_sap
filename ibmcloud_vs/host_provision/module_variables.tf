
variable "module_var_ibmcloud_vpc_subnet_name" {}

variable "module_var_resource_prefix" {}

variable "module_var_resource_tags" {}

variable "module_var_resource_group_id" {}

variable "module_var_virtual_server_hostname" {

  validation {
    condition     = length(var.module_var_virtual_server_hostname) <= 13
    error_message = "Hostname must be equal to or lower than 13 characters in length."
  }
}

variable "module_var_dns_root_domain_name" {}

variable "module_var_dns_services_instance" {}

variable "module_var_bastion_connection_security_group_id" {}

variable "module_var_host_security_group_id" {}

variable "module_var_bastion_ssh_port" {}

variable "module_var_bastion_floating_ip" {}

variable "module_var_bastion_private_ssh_key" {
  sensitive = false
}

variable "module_var_host_ssh_key_id" {}

variable "module_var_host_private_ssh_key" {
  sensitive = false
}

variable "module_var_bastion_user" {}

variable "module_var_virtual_server_profile" {}


variable "module_var_host_os_image" {}

variable "module_var_disable_ip_anti_spoofing" {
  default = false
}

variable "module_var_storage_definition" {}
