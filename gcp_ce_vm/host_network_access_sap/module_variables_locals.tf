
locals {
  network_rules_sap_nwas_abap_ascs_boolean = var.module_var_sap_nwas_abap_ascs_instance_no != "" ? true : false
  network_rules_sap_nwas_abap_pas_boolean  = var.module_var_sap_nwas_abap_pas_instance_no != "" ? true : false
  network_rules_sap_nwas_java_boolean      = var.module_var_sap_nwas_java_ci_instance_no != "" ? true : false
  network_rules_sap_hana_boolean           = var.module_var_sap_hana_instance_no != "" ? true : false
}
