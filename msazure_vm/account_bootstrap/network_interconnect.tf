
# Enable VNet Global Peering
# because the peering does not have a hub and must be declared/configured on each VNet to be peered, this code has been commented out

#variable "current_target_vnet_id" {
#  description = "Current target VNet ID"
#  default =""
#}

#variable "current_target_vnet_name" {
#  description = "Current target VNet Name"
#  default = ""
#}


#variable "remote_vnet_id" {
#  description = "Remote VNet ID "
#  default = ""
#}

#variable "remote_vnet_name" {
#  description = "Remote VNet Name"
#  default = ""
#}


#resource "azurerm_virtual_network_peering" "vnet1_peering_to_remote_vnet2" {
#  name                      = "${var.module_var_resource_prefix}-${var.current_target_vnet_name}-peering-to-${var.remote_vnet_name}"
#  resource_group_name       = var.module_var_az_resource_group_name
#  virtual_network_name      = var.current_target_vnet_name // VNet 1
#  remote_virtual_network_id = var.remote_vnet_id // VNet 2
#
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#
#  # VNet Global Peering requires gateway transit set to false
#  allow_gateway_transit = false
#}

#resource "azurerm_virtual_network_peering" "remote_vnet2_peering_to_vnet1" {
#  name                      = "${var.module_var_resource_prefix}-${var.remote_vnet_name}-peering-to-${var.current_target_vnet_name}"
#  resource_group_name       = var.module_var_az_resource_group_name
#  virtual_network_name      = var.remote_vnet_name // VNet 2
#  remote_virtual_network_id = var.current_target_vnet_id // VNet 1
#
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#
#  # VNet Global Peering requires gateway transit set to false
#  allow_gateway_transit = false
#}
