
# Select Subnet on the VPC in a specific Zone
### Also identifies target VPC and target Resource Group

data "ibm_is_subnet" "vpc_subnet" {
  provider = ibm.main
  name = var.module_var_ibmcloud_vpc_subnet_name // Requires unique name in account
}

data "ibm_is_vpc" "vpc" {
  provider = ibm.main
  name = data.ibm_is_subnet.vpc_subnet.vpc_name // Requires unique name in account
}
