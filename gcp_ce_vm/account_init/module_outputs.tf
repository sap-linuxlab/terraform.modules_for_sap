
output "output_vpc_subnet_name" {
  value = var.module_var_gcp_vpc_subnet_create_boolean ? google_compute_subnetwork.vpc_subnet[0].name : data.google_compute_subnetwork.vpc_subnet[0].name
}
