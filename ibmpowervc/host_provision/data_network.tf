
# Find PowerVC network details
data "openstack_networking_network_v2" "network" {
  name = var.module_var_ibmpowervc_network_name
}
