variable "module_var_az_resource_group_name" {}

variable "module_var_az_location_region" {} // aka. Azure Location Display Name

variable "module_var_az_location_availability_zone_no" {}

variable "module_var_resource_prefix" {}

variable "module_var_az_vnet_name" {}

variable "module_var_az_vnet_subnet_name" {}

variable "module_var_bastion_ssh_key_id" {}

variable "module_var_bastion_public_ssh_key" {}

variable "module_var_bastion_private_ssh_key" {}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_bastion_os_image" {}
