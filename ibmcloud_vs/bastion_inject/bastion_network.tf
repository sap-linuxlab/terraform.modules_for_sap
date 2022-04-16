
# Create Subnet for Bastion/Jump Host on the VPC in a specific Zone
# (which cannot be used by instances in different Zones)
#
# The ipv4_cidr_block is clean definition but static to a specific Zone,
# for dynamic Subnet CIDR use total_ipv4_address_count

resource "ibm_is_subnet" "vpc_bastion_subnet" {
  name           = "${var.module_var_resource_prefix}-bastion-subnet"
  resource_group = var.module_var_resource_group_id
  vpc            = local.target_vpc_id
  zone           = local.target_vpc_availability_zone
  ip_version     = "ipv4"
  #  ipv4_cidr_block = "10.240.62.0/29"
  total_ipv4_address_count = "8"
  #  network_acl =
}

