
# Create IBM Power VS Workspace
resource "ibm_pi_workspace" "power" {
  provider              = ibm.powervs_secure_enclave

  pi_name               = "${var.module_var_resource_prefix}-power-workspace"
  pi_datacenter         = var.module_var_ibmcloud_power_zone
  pi_resource_group_id  = var.module_var_resource_group_id
  pi_plan               = "public"

  # Increase operation timeout
  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}


# Sleep to ensure instance is ready
resource "null_resource" "sleep_temp" {
  depends_on = [ibm_pi_workspace.power]
  provisioner "local-exec" {
    command = "echo '----Sleep 30s to ensure IBM Power VS Workspace is ready to establish networks-----' && sleep 30"
  }
}
