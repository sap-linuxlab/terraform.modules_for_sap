
variable "module_var_bastion_boolean" {
}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_host_private_ip" {}

variable "module_var_bastion_floating_ip" {}

variable "module_var_bastion_private_ssh_key" {
  sensitive = false
}

variable "module_var_host_private_ssh_key" {
  sensitive = false
}

variable "module_var_hostname" {}

variable "module_var_sap_id_user" {}

variable "module_var_sap_id_user_password" {}

variable "module_var_sap_software_download_directory" {
  default = "/software"
}

variable "module_var_sap_hana_install_use_master_password" {
  default = "y"
}

variable "module_var_sap_hana_install_master_password" {
  default = "NewPass$321"
}

variable "module_var_sap_hana_install_sid" {
  default = "H01"
}

variable "module_var_sap_hana_install_instance_number" {
  default = "00"
}
