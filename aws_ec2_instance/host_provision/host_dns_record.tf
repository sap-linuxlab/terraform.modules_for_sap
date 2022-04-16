
# Create "A" (IPv4 Address) Resource Record to map IPv4 address as hostname / subdomain of the root domain name
# The input name becomes the "subdomain of the root domain"
resource "aws_route53_record" "dns_resource_record_a" {
  zone_id = var.module_var_dns_zone_id
  type    = "A"
  name    = var.module_var_host_name // Use Host Name given
  records = [aws_instance.host.private_ip]
  ttl     = 1800
}


# Canonical Name (CNAME) - Provides a way to alias a hostname to another hostname or Canonical Name (CNAME)
# "An A, AAAA or CNAME record already exists with that host" will appear if the key name has a value equal to any A, AAAA or CNAME record that exists
resource "aws_route53_record" "dns_resource_record_cname" {
  zone_id = var.module_var_dns_zone_id
  type    = "CNAME"
  name    = "${var.module_var_host_name}-short"
  records = ["${var.module_var_host_name}.${var.module_var_dns_root_domain_name}"]
  ttl     = 1800
}


# PTR (Pointer) - Enables reverse DNS lookup, from an IP address (IPv4 or IPv6) to a hostname
resource "aws_route53_record" "dns_resource_record_ptr" {
  zone_id = var.module_var_dns_zone_id
  type    = "PTR"
  name    = aws_instance.host.private_ip
  records = ["${var.module_var_host_name}.${var.module_var_dns_root_domain_name}"]
  ttl     = 1800
}
