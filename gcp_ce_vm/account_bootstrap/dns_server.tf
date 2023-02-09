
# DNS Services - Create a DNS Zone to hold Domain Names, attach the DNS Zone to a VPC
resource "google_dns_managed_zone" "private_dns_zone" {
  name        = "${var.module_var_resource_prefix}-vpc-dns"
  dns_name    = "${var.module_var_dns_root_domain_name}." // Must have period at end
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = local.target_vpc_id
    }
  }

}
