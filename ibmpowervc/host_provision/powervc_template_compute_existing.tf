
# Use existing IBM PowerVC LPAR Compute Template

data "openstack_compute_flavor_v2" "powervc_compute_template_existing" {
  count = var.module_var_ibmpowervc_template_compute_name_create_boolean ? 0 : 1

  name = var.module_var_ibmpowervc_template_compute_name
  #  swap = 0
  #  is_public = true
}
