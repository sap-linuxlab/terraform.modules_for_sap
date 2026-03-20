
variable "module_var_resource_prefix" {}

variable "module_var_gcp_region" {}

variable "module_var_gcp_region_zone" {}

variable "module_var_gcp_vpc_subnet_name" {}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_bastion_os_image" {}

variable "module_var_bastion_private_ssh_key" {}

variable "module_var_bastion_public_ssh_key" {}


# Enable on first boot only, not in subsequent executions
variable "module_var_bastion_grd_rdp_enable" { default = false }

variable "module_var_bastion_grd_rdp_user" { default = "rdpuser" }

variable "module_var_bastion_grd_rdp_user_password" { default = "" }

variable "module_var_bastion_grd_rdp_port" { default = 50333 }
