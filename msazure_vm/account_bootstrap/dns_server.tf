
# Private DNS Services - Create a Private DNS Zone to hold Domain Names
# The DNS Zone Name must be a fully qualified domain name (FQDN) and becomes the "root domain"
# During creation of a DNS Zone Name, only 2-level zones are supported (e.g. example.com)
# After DNS Zone Name is created, subdomains within the zone can be established (e.g. subdomain.example.com)
resource "azurerm_private_dns_zone" "dns_services_zone" {
  name                = var.module_var_dns_root_domain_name
  resource_group_name = var.module_var_az_resource_group_name
}


# Private DNS Services - Attach the DNS Zone to a VNet
# Used as an access control mechanism to guarantee that only the VNet can perform name resolution on the DNS zone
resource "azurerm_private_dns_zone_virtual_network_link" "dns_services_linked_network" {
  name                  = "${var.module_var_resource_prefix}-dns-link"
  resource_group_name   = var.module_var_az_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_services_zone.name
  virtual_network_id    = local.target_vnet_id
  registration_enabled  = false
}
