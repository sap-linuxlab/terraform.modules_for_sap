
# Select Subnet on the VPC in a specific Zone
### Also identifies target VPC and target Resource Group

data "ibm_is_subnet" "vpc_subnet" {
  name = var.module_var_ibmcloud_vpc_subnet_name
}

data "ibm_is_vpc" "vpc" {
  name = data.ibm_is_subnet.vpc_subnet.vpc_name
}
