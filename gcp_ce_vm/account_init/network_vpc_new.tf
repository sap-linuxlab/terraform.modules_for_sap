
# If not using existing VPC Subnet, then create VPC

# Create VPC
resource "google_compute_network" "vpc" {
  count         = var.module_var_gcp_vpc_subnet_create_boolean ? 1 : 0
  name          = "${var.module_var_resource_prefix}-vpc"
  routing_mode  = "REGIONAL" // Compute Network construct is Global, lock routing to 1 Region
  auto_create_subnetworks = false
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  count         = var.module_var_gcp_vpc_subnet_create_boolean ? 1 : 0
  name          = "${var.module_var_resource_prefix}-vpc-subnet"
  region        = var.module_var_gcp_region // Compute Subnetwork construct is for 1 Region
  network       = google_compute_network.vpc[0].id
  ip_cidr_range = "10.200.10.0/24"
  stack_type    = "IPV4_ONLY"
  private_ip_google_access = true
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
}
