
variable "module_var_az_resource_group_name" {}

variable "module_var_az_vnet_name" {}

variable "module_var_az_vnet_subnet_name" {}

variable "module_var_az_vnet_bastion_subnet_name" {}

variable "module_var_host_security_group_name" {}

variable "module_var_bastion_security_group_name" {}

variable "module_var_bastion_connection_security_group_name" {}

variable "module_var_sap_nwas_abap_pas_instance_no" {
  default = ""
}

variable "module_var_sap_nwas_java_ci_instance_no" {
  default = ""
}

variable "module_var_sap_hana_instance_no" {
  default = ""
}
