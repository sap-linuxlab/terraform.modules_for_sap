
variable "module_var_resource_prefix" {}

variable "module_var_gcp_region_zone" {}

variable "module_var_gcp_vpc_subnet_name" {}

variable "module_var_dns_zone_name" {}
variable "module_var_dns_root_domain_name" {}

variable "module_var_bastion_ip" {}
variable "module_var_bastion_user" {}
variable "module_var_bastion_ssh_port" {
  type = number
}
variable "module_var_bastion_private_ssh_key" {}

variable "module_var_host_os_image" {}
variable "module_var_host_ssh_public_key" {}
variable "module_var_host_ssh_private_key" {}

variable "module_var_virtual_machine_hostname" {}
variable "module_var_virtual_machine_profile" {}

variable "module_var_storage_definition" {}

variable "module_var_disable_ip_anti_spoofing" {
  default = false
}
