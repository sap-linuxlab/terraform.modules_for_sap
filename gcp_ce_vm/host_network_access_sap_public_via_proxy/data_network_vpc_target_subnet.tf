
# Select Subnet on the VPC Subnet in a specific Zone

data "google_compute_subnetwork" "vpc_subnet" {
  name = var.module_var_gcp_vpc_subnet_name
}

data "google_compute_network" "vpc" {
  name = basename(data.google_compute_subnetwork.vpc_subnet.network)
}

data "google_compute_subnetwork" "bastion_subnet" {
  name = var.module_var_bastion_subnet_name
}


locals {
  target_project_id       = data.google_compute_subnetwork.vpc_subnet.project
  target_vpc_name         = basename(data.google_compute_subnetwork.vpc_subnet.network)
  target_vpc_id           = data.google_compute_network.vpc.id
  target_vpc_uri          = data.google_compute_network.vpc.self_link
  target_vpc_subnet_id    = data.google_compute_subnetwork.vpc_subnet.id
  target_vpc_subnet_range = data.google_compute_subnetwork.vpc_subnet.ip_cidr_range
  target_gateway_address  = data.google_compute_subnetwork.vpc_subnet.gateway_address

  bastion_vpc_subnet_range = data.google_compute_subnetwork.bastion_subnet.ip_cidr_range
}



