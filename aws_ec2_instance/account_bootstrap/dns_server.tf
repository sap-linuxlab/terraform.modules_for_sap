
# DNS Services - Add the private DNS Resource Record (of a specific host in the VPC) for the DNS Zone
#
### Record Types = A, AAAA, CNAME, MX, PTR, SRV, TXT
### Time To Live = Maximum 12 hours, before the host / local resolver should remove from local cache

# Create DNS Services instance, add DNS Zone to hold Domain Names and attach DNS Zone to a VPC
resource "aws_route53_zone" "dns_services_zone" {
  name = var.module_var_dns_root_domain_name

  vpc {
    vpc_id = local.target_vpc_id
  }

  tags = {
    Name = "${var.module_var_resource_prefix}-dns"
  }
}
