# Select Resource Group

data "azurerm_resource_group" "resource_group" {
  count = var.module_var_az_resource_group_create_boolean ? 0 : 1
  name  = var.module_var_az_resource_group_name
}
