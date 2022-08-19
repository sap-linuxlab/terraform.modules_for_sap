
locals {
  network_rules_sap_nwas_boolean = var.module_var_sap_nwas_pas_instance_no != null ? true : false
  network_rules_sap_hana_boolean = var.module_var_sap_hana_instance_no != null ? true : false

  target_resource_group_id     = data.ibm_is_subnet.vpc_subnet.resource_group
  target_vpc_id                = data.ibm_is_subnet.vpc_subnet.vpc
  target_vpc_crn               = data.ibm_is_vpc.vpc.crn
  target_vpc_availability_zone = data.ibm_is_subnet.vpc_subnet.zone
  target_vpc_subnet_range      = data.ibm_is_subnet.vpc_subnet.ipv4_cidr_block
  target_region                = replace(data.ibm_is_subnet.vpc_subnet.zone, "/-[^-]*$/", "")
  target_subnet_id             = data.ibm_is_subnet.vpc_subnet.id
}
