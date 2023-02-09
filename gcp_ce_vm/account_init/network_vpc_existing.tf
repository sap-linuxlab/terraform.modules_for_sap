
# Select Subnet on the VPC Subnet in a specific Zone

data "google_compute_subnetwork" "vpc_subnet" {
  count = var.module_var_gcp_vpc_subnet_create_boolean ? 0 : 1
  name = var.module_var_gcp_vpc_subnet_name
}

locals {
  target_vpc              = data.google_compute_subnetwork.vpc_subnet[*].network
  target_vpc_subnet_range = data.google_compute_subnetwork.vpc_subnet[*].ip_cidr_range
  target_gateway_address  = data.google_compute_subnetwork.vpc_subnet[*].gateway_address
}
