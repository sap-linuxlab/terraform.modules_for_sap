# Select Resource Group

data "ibm_resource_group" "resource_group" {
  count = var.module_var_resource_group_create_boolean ? 0 : 1
  name  = var.module_var_resource_group_name
}
