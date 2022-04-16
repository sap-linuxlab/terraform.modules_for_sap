# Select Subnet on the VPC in a specific Zone
### Also identifies target VPC, Region and Resource Group

data "ibm_is_subnet" "vpc_subnet" {
  count = var.module_var_ibmcloud_vpc_subnet_create_boolean ? 0 : 1
  name  = var.module_var_ibmcloud_vpc_subnet_name
}

locals {
  target_resource_group_id     = data.ibm_is_subnet.vpc_subnet[*].resource_group
  target_vpc_id                = data.ibm_is_subnet.vpc_subnet[*].vpc
  target_vpc_availability_zone = data.ibm_is_subnet.vpc_subnet[*].zone
  target_region                = try(replace(data.ibm_is_subnet.vpc_subnet[*].zone, "/-[^-]*$/", ""), null)
  target_subnet_id             = join("", data.ibm_is_subnet.vpc_subnet[*].id)
  target_subnet_ip_range       = data.ibm_is_subnet.vpc_subnet[*].ipv4_cidr_block
  target_subnet_public_gateway = join("", data.ibm_is_subnet.vpc_subnet[*].public_gateway)
}
