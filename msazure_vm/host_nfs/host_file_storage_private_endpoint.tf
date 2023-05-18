
# Create Azure Storage Account Private Endpoint connection
resource "azurerm_private_endpoint" "endpoint" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0
  name                = "${var.module_var_resource_prefix}stgacc${random_string.random_suffix.result}-private-endpoint"
  resource_group_name = var.module_var_az_resource_group_name
  location            = var.module_var_az_location_region
  subnet_id           = local.target_vnet_subnet_id

  private_service_connection {
    name                           = "${var.module_var_resource_prefix}stgacc${random_string.random_suffix.result}-private-service-connection"
    private_connection_resource_id = azapi_resource.storage_account_sap[0].id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = var.module_var_dns_zone_name
    private_dns_zone_ids = ["${data.azurerm_private_dns_zone.vnet_private_dns.id}"]
  }

}


# Create DNS A Records
# This is alternative to creating the default private endpoint with a new Private DNS Zone 'privatelink.file.core.windows.net'
resource "azurerm_private_dns_a_record" "dns_a_record_short" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0
  name                = "${var.module_var_resource_prefix}stgacc${random_string.random_suffix.result}"
  resource_group_name = var.module_var_az_resource_group_name
  zone_name           = var.module_var_dns_zone_name
  ttl                 = 1000
  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
}
