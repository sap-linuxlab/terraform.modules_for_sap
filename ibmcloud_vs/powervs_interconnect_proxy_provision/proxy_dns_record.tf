
# DNS Services - Add the private DNS Resource Record (of a specific Virtual Server in the VPC) for the DNS Zone
#
### Record Types = A, AAAA, CNAME, MX, PTR, SRV, TXT
### Time To Live = Maximum 12 hours, before the host / local resolver should remove from local cache
#
# Subdomains to any of the restricted 2-level DNS Zone names are not permitted (https://cloud.ibm.com/docs/dns-svcs?topic=dns-svcs-managing-dns-zones#restricted-dns-zone-names):
#    ibm.com
#    softlayer.com
#    bluemix.net
#    softlayer.local
#    mybluemix.net
#    networklayer.com
#    ibmcloud.com
#    pdnsibm.net
#    appdomain.cloud


# Create "A" (IPv4 Address) Resource Record to map IPv4 address as hostname / subdomain of the root domain name
# The input name becomes the "subdomain of the root domain"
resource "ibm_dns_resource_record" "dns_resource_record_a" {
  instance_id = data.ibm_resource_instance.dns_services_instance.guid
  zone_id     = local.target_dns_zone_id
  type        = "A"
  name        = ibm_is_instance.proxy_virtual_server.name // Use Host Name given to the Virtual Server
  rdata       = ibm_is_instance.proxy_virtual_server.primary_network_attachment[0].virtual_network_interface[0].primary_ip[0].address
  ttl         = 1800
}

# Canonical Name (CNAME) - Provides a way to alias a hostname to another hostname or Canonical Name (CNAME)
# "An A, AAAA or CNAME record already exists with that host" will appear if the key name has a value equal to any A, AAAA or CNAME record that exists
resource "ibm_dns_resource_record" "dns_resource_record_cname" {
  instance_id = data.ibm_resource_instance.dns_services_instance.guid
  zone_id     = local.target_dns_zone_id
  type        = "CNAME"
  name        = "${ibm_is_instance.proxy_virtual_server.name}-short" // Create new Alias of the Host Name given to the Virtual Server
  rdata       = "${ibm_is_instance.proxy_virtual_server.name}.${var.module_var_dns_root_domain_name}" // Is an Alias of the actual Host Name and Domain
  ttl         = 1800

  # Force reference to the A record and increase timout, ensuring any destroy action will not have linked record errors
  depends_on = [ibm_dns_resource_record.dns_resource_record_a]

  # Increase operation timeout
  timeouts {
    create = "10m"
    delete = "10m"
  }
}

# PTR (Pointer) - Enables reverse DNS lookup, from an IP address (IPv4 or IPv6) to a hostname
resource "ibm_dns_resource_record" "dns_resource_record_ptr" {
  instance_id = data.ibm_resource_instance.dns_services_instance.guid
  zone_id     = local.target_dns_zone_id
  type        = "PTR"
  name        = ibm_is_instance.proxy_virtual_server.primary_network_attachment[0].virtual_network_interface[0].primary_ip[0].address
  rdata       = "${ibm_is_instance.proxy_virtual_server.name}.${var.module_var_dns_root_domain_name}"
  ttl         = 1800

  # Force reference to the A record and increase timout, ensuring any destroy action will not have linked record errors
  depends_on = [ibm_dns_resource_record.dns_resource_record_a]

  # Increase operation timeout
  timeouts {
    create = "10m"
    delete = "10m"
  }
}


resource "ibm_dns_custom_resolver" "dns_custom_powervs" {
  instance_id        =  data.ibm_resource_instance.dns_services_instance.guid
  name               =  "${var.module_var_resource_prefix}-dns-custom-resolver-pvs"
  high_availability  =  false
  enabled            =  true

  locations {
    subnet_crn  = data.ibm_is_subnet.vpc_subnet.crn
    enabled     = true
  }

}
