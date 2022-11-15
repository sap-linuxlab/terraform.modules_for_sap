
data "azurerm_platform_image" "bastion_os_image" {
  location  = var.module_var_az_location_region
  publisher = var.module_var_bastion_os_image.publisher
  offer     = var.module_var_bastion_os_image.offer
  sku       = var.module_var_bastion_os_image.sku
}

#output "debug_bastion_os_image" {
#  value = data.azurerm_platform_image.bastion_os_image.id
#}
