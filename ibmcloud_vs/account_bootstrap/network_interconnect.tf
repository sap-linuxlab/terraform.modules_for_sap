
# Create Transit Gateway to connect VPC to VPC, with Local Routing
# Max of 2 per Region

resource "ibm_tg_gateway" "tg_gateway" {
  name           = "${var.module_var_resource_prefix}-tg"
  location       = local.target_region
  global         = false
  resource_group = var.module_var_resource_group_id
}

resource "ibm_tg_connection" "tg_connection_to_vpc" {
  depends_on   = [ibm_tg_gateway.tg_gateway]
  name         = "${var.module_var_resource_prefix}-tg-connection-to-vpc"
  gateway      = ibm_tg_gateway.tg_gateway.id
  network_type = "vpc"
  network_id   = local.target_vpc_crn
}
