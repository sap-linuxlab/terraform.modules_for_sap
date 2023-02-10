
resource "google_compute_router" "vpc_router" {
  count   = var.module_var_gcp_vpc_subnet_create_boolean ? 1 : 0
  name    = "${var.module_var_resource_prefix}-vpc-router"
  network = google_compute_network.vpc[0].id
  region  = google_compute_subnetwork.vpc_subnet[0].region
}

resource "google_compute_router_nat" "vpc_snat" {
  count                              = var.module_var_gcp_vpc_subnet_create_boolean ? 1 : 0
  name                               = "${var.module_var_resource_prefix}-vpc-snat"
  router                             = google_compute_router.vpc_router[0].name
  region                             = google_compute_router.vpc_router[0].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
