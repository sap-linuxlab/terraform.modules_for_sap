
# Create "A" (IPv4 Address) Resource Record to map IPv4 address as hostname / subdomain of the root domain name
# The input name becomes the "subdomain of the root domain"
resource "azurerm_private_dns_a_record" "dns_resource_record_a" {
  name                = var.module_var_host_name // Use Host Name given
  zone_name           = var.module_var_dns_zone_name
  resource_group_name = var.module_var_az_resource_group_name
  ttl                 = 1800
  records             = [azurerm_linux_virtual_machine.host.private_ip_address]
}


# Canonical Name (CNAME) - Provides a way to alias a hostname to another hostname or Canonical Name (CNAME)
# "An A, AAAA or CNAME record already exists with that host" will appear if the key name has a value equal to any A, AAAA or CNAME record that exists
resource "azurerm_private_dns_cname_record" "dns_resource_record_cname" {
  name                = "${var.module_var_host_name}-short"
  zone_name           = var.module_var_dns_zone_name
  resource_group_name = var.module_var_az_resource_group_name
  ttl                 = 1800
  record              = "${var.module_var_host_name}.${var.module_var_dns_root_domain_name}"
}


# PTR (Pointer) - Enables reverse DNS lookup, from an IP address (IPv4 or IPv6) to a hostname
resource "azurerm_private_dns_ptr_record" "dns_resource_record_ptr" {
  name                = azurerm_linux_virtual_machine.host.private_ip_address
  zone_name           = var.module_var_dns_zone_name
  resource_group_name = var.module_var_az_resource_group_name
  ttl                 = 1800
  records             = ["${var.module_var_host_name}.${var.module_var_dns_root_domain_name}"]
}
