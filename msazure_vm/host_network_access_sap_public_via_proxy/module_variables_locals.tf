
locals {
  network_rules_sap_nwas_abap_boolean = var.module_var_sap_nwas_abap_pas_instance_no != "" ? true : false
  network_rules_sap_nwas_java_boolean = var.module_var_sap_nwas_java_ci_instance_no != "" ? true : false
  network_rules_sap_hana_boolean = var.module_var_sap_hana_instance_no != "" ? true : false

  target_resource_group_name = var.module_var_az_resource_group_name
  target_resource_group_id   = data.azurerm_resource_group.resource_group.id

  target_vnet_name = var.module_var_az_vnet_name
  target_vnet_id   = data.azurerm_virtual_network.vnet.id
  target_vnet_guid = data.azurerm_virtual_network.vnet.guid

  target_vnet_subnet_name  = var.module_var_az_vnet_subnet_name
  target_vnet_subnet_id    = data.azurerm_subnet.vnet_subnet.id
  target_vnet_subnet_range = data.azurerm_subnet.vnet_subnet.address_prefix

  target_vnet_bastion_subnet_id = data.azurerm_subnet.vnet_bastion_subnet.id
  target_vnet_bastion_subnet_range = data.azurerm_subnet.vnet_bastion_subnet.address_prefixes[0]

}
