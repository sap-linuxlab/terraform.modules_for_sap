
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

variable "module_var_sap_swpm_master_password" {
  default = "NewPass$321"
}
variable "module_var_sap_swpm_db_system_password" {
  default = "NewPass$321"
}
variable "module_var_sap_swpm_db_systemdb_password" {
  default = "NewPass$321"
}
variable "module_var_sap_swpm_db_sidadm_password" {
  default = "NewPass$321"
}
variable "module_var_sap_swpm_sid" {}
variable "module_var_sap_swpm_pas_instance_nr" {
  default = "01"
}
variable "module_var_sap_swpm_ascs_instance_nr" {
  default = "02"
}
variable "module_var_dns_root_domain_name" {}

# Variables required for extracting backup Database Schema (e.g. SAPABAP1), using the Schema Password, Schema SYSTEM Password and DDIC Password
variable "module_var_sap_swpm_db_schema_abap" {}
variable "module_var_sap_swpm_db_schema_abap_password" {}
variable "module_var_sap_swpm_ddic_000_password" {}

variable "module_var_sap_swpm_template_selected" {}

variable "module_var_dry_run_test" {
  default = ""
}

variable "module_var_terraform_host_specification_storage_definition" {
  default = {}
}
