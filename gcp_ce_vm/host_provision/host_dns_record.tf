
# Create "A" (IPv4 Address) Resource Record to map IPv4 address as hostname / subdomain of the root domain name
# The input name becomes the "subdomain of the root domain"
resource "google_dns_record_set" "dns_resource_record_a" {
  managed_zone = var.module_var_dns_zone_name
  type         = "A"
  name         = "${var.module_var_virtual_machine_hostname}.${var.module_var_dns_root_domain_name}." // Use FQDN, must have period at end
  rrdatas      = [google_compute_instance.host.network_interface[0].network_ip]
  ttl          = 1000
}


# Canonical Name (CNAME) - Provides a way to alias a hostname to another hostname or Canonical Name (CNAME)
# "An A, AAAA or CNAME record already exists with that host" will appear if the key name has a value equal to any A, AAAA or CNAME record that exists
resource "google_dns_record_set" "dns_resource_record_cname" {
  managed_zone = var.module_var_dns_zone_name
  type         = "CNAME"
  name         = "${var.module_var_virtual_machine_hostname}-short.${var.module_var_dns_root_domain_name}." // Use FQDN, must have period at end
  rrdatas      = ["${var.module_var_virtual_machine_hostname}.${var.module_var_dns_root_domain_name}."] // Use FQDN, must have period at end
  ttl          = 1000
}
