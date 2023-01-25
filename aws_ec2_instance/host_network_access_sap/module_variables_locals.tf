
locals {
  network_rules_sap_nwas_abap_ascs_boolean = var.module_var_sap_nwas_abap_ascs_instance_no != "" ? true : false
  network_rules_sap_nwas_abap_pas_boolean = var.module_var_sap_nwas_abap_pas_instance_no != "" ? true : false
  network_rules_sap_nwas_java_boolean = var.module_var_sap_nwas_java_ci_instance_no != "" ? true : false
  network_rules_sap_hana_boolean = var.module_var_sap_hana_instance_no != "" ? true : false

  target_vpc_id                = data.aws_subnet.vpc_subnet.vpc_id
  target_vpc_availability_zone = data.aws_subnet.vpc_subnet.availability_zone
  target_subnet_ip_range       = data.aws_subnet.vpc_subnet.cidr_block
}
