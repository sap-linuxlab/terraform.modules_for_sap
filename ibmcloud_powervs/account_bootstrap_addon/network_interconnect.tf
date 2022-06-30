
# IBM Power Virtual Server Cloud Connections utilises IBM Cloud DirectLink 2.0 Connect
# As of Feb-2022, this feature is not available in Toronto 1 (TOR01) and Washington 6 (WDC06)
#
### This will create an IBM Cloud DirectLink 2.0 instance with a Virtual Connection to a VPC.
### The IBM Cloud DirectLink 2.0 instance will remain in 'Idle' status until the IBM Power Virtual Server Cloud Connection has a IBM Power private network subnet attached.
### Once a IBM Power private network subnet is attached, the IBM Cloud DirectLink 2.0 instance will reflect 'Established' status.
resource "ibm_pi_cloud_connection" "cloud_connection" {
  depends_on = [
    null_resource.sleep_temp_network
  ]

  pi_cloud_instance_id               = ibm_resource_instance.power_group.guid
  pi_cloud_connection_name           = "${var.module_var_resource_prefix}-pwr-to-cld"
  pi_cloud_connection_global_routing = false
  pi_cloud_connection_speed          = 200 // Mbps

  pi_cloud_connection_vpc_enabled = true

  pi_cloud_connection_vpc_crns = [
    local.target_vpc_crn
  ]

  pi_cloud_connection_networks = [
    ibm_pi_network.power_group_network_private.network_id
  ]

  # Increase operation timeout
  timeouts {
    create = "90m"
    delete = "30m"
  }

}

resource "null_resource" "wait_for_cloud_connection" {

  depends_on = [
    ibm_pi_cloud_connection.cloud_connection
  ]

  provisioner "local-exec" {
    command = "echo '----Sleep 90s to ensure IBM Power Virtual Server Cloud Connections (using IBM Cloud DirectLink 2.0 Connect) is ready-----' && sleep 90"
  }

}
