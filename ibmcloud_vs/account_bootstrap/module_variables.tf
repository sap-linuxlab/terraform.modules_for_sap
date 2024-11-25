
variable "module_var_bastion_user" {
}

variable "module_var_bastion_ssh_port" {
  type    = number
  default = 50222
}

variable "module_var_ibmcloud_vpc_availability_zone" {}

variable "module_var_dns_root_domain_name" {}

variable "module_var_ibmcloud_vpc_subnet_name" {}

variable "module_var_resource_prefix" {}

variable "module_var_resource_group_id" {}
