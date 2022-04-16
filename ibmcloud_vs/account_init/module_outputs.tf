
output "output_resource_group_id" {
  value = var.module_var_resource_group_create_boolean ? ibm_resource_group.resource_group[0].id : data.ibm_resource_group.resource_group[0].id
}

output "output_vpc_subnet_name" {
  value = var.module_var_ibmcloud_vpc_subnet_create_boolean ? ibm_is_subnet.vpc_subnet[0].name : var.module_var_ibmcloud_vpc_subnet_name
}
