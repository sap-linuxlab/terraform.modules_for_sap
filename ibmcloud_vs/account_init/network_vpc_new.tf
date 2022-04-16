# If not using existing VPC Subnet, then create VPC
# Name of VPC must be unique within the Account

resource "ibm_is_vpc" "vpc" {
  count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 1 : 0

  name           = "${var.module_var_resource_prefix}-vpc"
  resource_group = var.module_var_resource_group_create_boolean ? ibm_resource_group.resource_group[0].id : data.ibm_resource_group.resource_group[0].id
  #  default_network_acl = ibm_is_network_acl.vpc_subnet_acl.id
  #  default_security_group = ibm_is_security_group.vpc_sg.id
  #  classic_access = false
  #  address_prefix_management = "manual"
}


#resource "ibm_is_vpc_address_prefix" "vpc_manual_prefix" {
#  depends_on = [ibm_is_vpc.vpc]
#  name = "vpc-prefix-1"
#  vpc  = ibm_is_vpc.vpc.id
#  zone = "${var.module_var_ibmcloud_vpc_availability_zone}"
#  cidr = "10.240.0.0/16"
#}


# Create Subnet on the VPC in a specific Zone
# (which cannot be used by instances in different Zones)
#
# The ipv4_cidr_block is clean definition but static to a specific Zone, 
# for dynamic Subnet CIDR use total_ipv4_address_count

resource "ibm_is_subnet" "vpc_subnet" {
  count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 1 : 0

  name           = "${var.module_var_resource_prefix}-vpc-subnet"
  resource_group = var.module_var_resource_group_create_boolean ? ibm_resource_group.resource_group[0].id : data.ibm_resource_group.resource_group[0].id
  vpc            = var.module_var_ibmcloud_vpc_subnet_create_boolean ? join(",", ibm_is_vpc.vpc[*].id) : join(",", local.target_vpc_id)
  zone           = var.module_var_ibmcloud_vpc_availability_zone
  #  ip_version      = "ipv4"
  #  ipv4_cidr_block = "10.240.0.0/24"
  total_ipv4_address_count = "256"
  #  network_acl_name = ibm_is_network_acl.vpc_subnet_acl.name
  public_gateway = ibm_is_public_gateway.vpc_subnet_public_gateway[0].id
}
