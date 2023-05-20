
variable "module_var_az_resource_group_name" {}

variable "module_var_az_location_region" {} // aka. Azure Location Display Name

variable "module_var_az_location_availability_zone_no" {}

variable "module_var_resource_prefix" {}

variable "module_var_az_vnet_name" {}

variable "module_var_az_vnet_subnet_name" {}

variable "module_var_bastion_private_ssh_key" {}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_host_os_image" {}

variable "module_var_host_name" {}


variable "module_var_host_ssh_key_id" {}

variable "module_var_host_ssh_public_key" {}

variable "module_var_host_ssh_private_key" {}

variable "module_var_host_sg_id" {}


variable "module_var_bastion_ip" {}

variable "module_var_bastion_connection_sg_id" {}



variable "module_var_az_vm_instance" {}


variable "module_var_dns_zone_name" {}

variable "module_var_dns_root_domain_name" {}

variable "module_var_storage_definition" {}

variable "module_var_disable_ip_anti_spoofing" {
  default = false
}
