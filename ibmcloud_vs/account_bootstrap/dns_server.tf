
# Create DNS Services instance
# DNS Services creates a DNS Zone which routes private network traffic for a defined Domain Name/s to any selected VPC Zones (in any Region, up to 10 VPCs)
#
# DNS Services is private only and hidden / not accessible from machines outside of IBM Cloud. For provisioning and configuring DNS Resource Records for public DNS resolution, refer to IBM Cloud Internet Services (CIS)
#
# When the DNS Services resolver receives a request, it checks whether the request is for a hostname defined within a private zone for the network where the request originated.
# If so, the hostname is resolved privately. Otherwise, the request is forwarded to a public resolver and the response returned to the requester.
# This allows for a hostname such as www.example.com to resolve differently on the internet versus on IBM Cloud.
#
# Adding the same VPC to two DNS zones of the same name is not allowed.

resource "ibm_resource_instance" "dns_services_instance" {
  name    = "${var.module_var_resource_prefix}-dns"
  service = "dns-svcs"
  plan    = "standard-dns"

  resource_group_id = var.module_var_resource_group_id
  location          = "global"
}


# DNS Services - Create a DNS Zone to hold Domain Names
# The DNS Zone Name must be a fully qualified domain name (FQDN) and becomes the "root domain"
# During creation of a DNS Zone Name, only 2-level zones are supported (e.g. example.com)
# After DNS Zone Name is created, subdomains within the zone can be established (e.g. subdomain.example.com)

resource "ibm_dns_zone" "dns_services_zone" {
  depends_on  = [ibm_resource_instance.dns_services_instance]
  name        = var.module_var_dns_root_domain_name
  instance_id = ibm_resource_instance.dns_services_instance.guid
  description = "${var.module_var_resource_prefix} Private DNS Zone"
  label       = "dns_zone"
}


# DNS Services - Add Permitted Network, attach the DNS Zone to a VPC
# Used as an access control mechanism to guarantee that only the VPC that has been added as a permitted network can perform name resolution on the DNS zone

resource "ibm_dns_permitted_network" "dns_services_permitted_network" {
  depends_on  = [ibm_dns_zone.dns_services_zone]
  instance_id = ibm_resource_instance.dns_services_instance.guid
  zone_id     = ibm_dns_zone.dns_services_zone.zone_id
  vpc_crn     = local.target_vpc_crn
  type        = "vpc"
}
