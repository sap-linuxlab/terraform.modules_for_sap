
variable "module_var_resource_prefix" {}

variable "module_var_resource_tags" {}

variable "module_var_resource_group_id" {}


variable "module_var_ibmcloud_vpc_subnet_name" {}

variable "module_var_bastion_ssh_port" {}

variable "module_var_host_public_ssh_key" {}

variable "module_var_virtual_server_profile" {}

variable "module_var_virtual_server_hostname" {

  validation {
    condition     = length(var.module_var_virtual_server_hostname) <= 13
    error_message = "Hostname must be equal to or lower than 13 characters in length."
  }
}

variable "module_var_host_os_image" {}

variable "module_var_bastion_user" {}

variable "module_var_ibm_power_group_guid" {}

variable "module_var_power_group_networks" {}

variable "module_var_bastion_ip" {}

variable "module_var_bastion_private_ssh_key" {
  sensitive = false
}

variable "module_var_host_private_ssh_key" {
  sensitive = false
}


variable "module_var_dns_root_domain_name" {}

variable "module_var_dns_services_instance" {}


variable "module_var_dns_proxy_ip" {}


variable "module_var_web_proxy_enable" {
  default = true
}
variable "module_var_web_proxy_url" {}
variable "module_var_web_proxy_exclusion" {}


variable "module_var_os_vendor_enable" {
  default = true
}
variable "module_var_os_vendor_account_user" {}
variable "module_var_os_vendor_account_user_passcode" {}

variable "module_var_storage_definition" {}
