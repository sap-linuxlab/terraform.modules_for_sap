
# Create Subnet on the VPC

resource "google_compute_subnetwork" "vpc_bastion_subnet" {
  name          = "${var.module_var_resource_prefix}-vpc-bastion-subnet"
  region        = var.module_var_gcp_region // Compute Subnetwork construct is for 1 Region
  network       = local.target_vpc_id
  ip_cidr_range = "10.200.240.0/28"
  stack_type    = "IPV4_ONLY"
  private_ip_google_access = false
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
}
