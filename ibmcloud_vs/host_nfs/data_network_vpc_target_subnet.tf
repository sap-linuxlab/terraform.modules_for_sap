
# Select Subnet on the VPC in a specific Zone
### Also identifies target VPC and target Resource Group

data "ibm_is_subnet" "vpc_subnet" {
  name = var.module_var_ibmcloud_vpc_subnet_name
}

data "ibm_is_vpc" "vpc" {
  name = data.ibm_is_subnet.vpc_subnet.vpc_name
}

locals {
  target_resource_group_id     = data.ibm_is_subnet.vpc_subnet.resource_group
  target_vpc_id                = data.ibm_is_subnet.vpc_subnet.vpc
  target_vpc_crn               = data.ibm_is_vpc.vpc.crn
  target_vpc_availability_zone = data.ibm_is_subnet.vpc_subnet.zone
  target_vpc_subnet_range      = data.ibm_is_subnet.vpc_subnet.ipv4_cidr_block
  target_region                = replace(data.ibm_is_subnet.vpc_subnet.zone, "/-[^-]*$/", "")
  target_subnet_id             = data.ibm_is_subnet.vpc_subnet.id
}
