# Create Resource Group

resource "ibm_resource_group" "resource_group" {
  count = var.module_var_resource_group_create_boolean ? 1 : 0
  name  = "${var.module_var_resource_prefix}-rg"
}
