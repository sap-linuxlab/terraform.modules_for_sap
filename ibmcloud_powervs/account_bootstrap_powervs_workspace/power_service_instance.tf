
# Create IBM POWER Virtual Server Group resource instance
#
# Find resource instances from IBM Cloud Catalog Service Marketplace using IBM Cloud CLI > ibmcloud catalog service-marketplace
# Equivilant command in IBM Cloud CLI is > ibmcloud resource service-instance-create test-power power-iaas power-virtual-server-group us-south -g Default
#
# Show list of IBM Power VS Zones using IBM Cloud CLI by executing, ibmcloud catalog service power-iaas --output json | jq .[].children[].children[].metadata.deployment.location

resource "ibm_resource_instance" "power_group" {
  name    = "${var.module_var_resource_prefix}-power-group-instance"
  service = "power-iaas"
  plan    = "power-virtual-server-group"

  resource_group_id = var.module_var_resource_group_id
  location          = var.module_var_ibmcloud_power_zone

  # Increase operation timeout
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}


# Sleep to ensure instance is ready
resource "null_resource" "sleep_temp" {
  depends_on = [ibm_resource_instance.power_group]
  provisioner "local-exec" {
    command = "echo '----Sleep 30s to ensure power group instance is ready to establish networks-----' && sleep 30"
  }
}
