variable "module_var_resource_prefix" {}

variable "module_var_aws_vpc_subnet_id" {}

variable "module_var_aws_vpc_igw_id" {}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_bastion_os_image" {}

variable "module_var_bastion_ssh_key_name" {}

variable "module_var_bastion_private_ssh_key" {}

variable "module_var_bastion_public_ssh_key" {}

variable "module_var_aws_vpc_availability_zone" {}
