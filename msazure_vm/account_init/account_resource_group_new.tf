# Create Resource Group

resource "azurerm_resource_group" "resource_group" {
  count    = var.module_var_az_resource_group_create_boolean ? 1 : 0
  name     = "${var.module_var_resource_prefix}-rg"
  location = var.module_var_az_location_region
}
