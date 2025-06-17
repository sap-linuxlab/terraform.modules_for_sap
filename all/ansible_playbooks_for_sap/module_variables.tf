
variable "module_var_bastion_boolean" {}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_bastion_floating_ip" {}

variable "module_var_bastion_private_ssh_key" {
  sensitive = false
}

variable "module_var_host_private_ssh_key" {
  sensitive = false
}

variable "module_var_host_specifications" {}
variable "module_var_host_specification_plan" {}
variable "module_var_host_provision_outputs" {}

variable "module_var_dns_root_domain" {}

variable "module_var_nfs_fqdn_sapmnt" {
  default = ""
}

variable "module_var_nfs_fqdn_transport" {
  default = ""
}

variable "module_var_ansible_sap_scenario_selection" {}
variable "module_var_ansible_sap_software_product" {}
variable "module_var_ansible_sap_id_user" {}
variable "module_var_ansible_sap_id_user_password" {}
variable "module_var_ansible_sap_system_sid" {}
variable "module_var_ansible_sap_system_hana_db_sid" {}
variable "module_var_ansible_sap_system_hana_db_instance_nr" {}
variable "module_var_ansible_sap_system_anydb_sid" {}
variable "module_var_ansible_sap_system_nwas_abap_ascs_instance_nr" {}
variable "module_var_ansible_sap_system_nwas_abap_pas_instance_nr" {}
variable "module_var_ansible_sap_system_nwas_abap_aas_instance_nr" {}
variable "module_var_ansible_sap_system_nwas_java_scs_instance_nr" {}
variable "module_var_ansible_sap_system_nwas_java_ci_instance_nr" {}
variable "module_var_ansible_sap_maintenance_planner_transaction_name" {}
variable "module_var_ansible_sap_software_download_directory" {}

variable "module_var_ibmpower_flag" {
  default = false
}
