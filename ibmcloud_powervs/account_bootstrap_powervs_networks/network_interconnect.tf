
data "ibm_pi_workspace" "power_info" {
  provider              = ibm.powervs_secure_enclave
  pi_cloud_instance_id  = var.module_var_ibmcloud_powervs_workspace_guid
}


# IBM Cloud Transit Gateway Connection to IBM Power Workspace, using backend Power Edge Router (PER) connectivity

data "ibm_tg_gateway" "tgw_existing" {
  provider = ibm.main
  name     = var.module_var_ibmcloud_tgw_instance_name
}

resource "ibm_tg_connection" "tgw_connection_to_power" {
  provider     = ibm.main

  gateway      = data.ibm_tg_gateway.tgw_existing.id

  name         = "${var.module_var_resource_prefix}-power-connect"
  network_type = "power_virtual_server"
  network_id   = data.ibm_pi_workspace.power_info.pi_workspace_details[0].crn # IBM Power Virtual Server Workspace CRN
}


# IBM Power Virtual Server Cloud Connections utilises IBM Cloud DirectLink 2.0 Connect
# As of Feb-2022, this network feature is not available in Toronto 1 (TOR01) and Washington 6 (WDC06)
# As of Mar-2024, this network feature is legacy in most locations and replaced by IBM Cloud Transit Gateway connections
#
### This will create an IBM Cloud DirectLink 2.0 instance with a Virtual Connection to a VPC.
### The IBM Cloud DirectLink 2.0 instance will remain in 'Idle' status until the IBM Power Virtual Server Cloud Connection has a IBM Power private network subnet attached.
### Once a IBM Power private network subnet is attached, the IBM Cloud DirectLink 2.0 instance will reflect 'Established' status.

# resource "ibm_pi_cloud_connection" "cloud_connection" {

#   provider              = ibm.powervs_secure_enclave

#   depends_on = [
#     null_resource.sleep_temp_network
#   ]

#   pi_cloud_instance_id               = var.module_var_ibmcloud_powervs_workspace_guid
#   pi_cloud_connection_name           = "${var.module_var_resource_prefix}-pwr-to-cld"
#   pi_cloud_connection_global_routing = false
#   pi_cloud_connection_speed          = 200 // Mbps

#   pi_cloud_connection_vpc_enabled = true

#   pi_cloud_connection_vpc_crns = [
#     var.module_var_ibmcloud_vpc_crn
#   ]

#   pi_cloud_connection_networks = [
#     ibm_pi_network.power_network_private.network_id
#   ]

#   # Increase operation timeout
#   timeouts {
#     create = "90m"
#     delete = "30m"
#   }

# }

# resource "null_resource" "wait_for_cloud_connection" {

#   depends_on = [
#     ibm_pi_cloud_connection.cloud_connection
#   ]

#   provisioner "local-exec" {
#     command = "echo '----Sleep 90s to ensure IBM Power Virtual Server Cloud Connections (using IBM Cloud DirectLink 2.0 Connect) is ready-----' && sleep 90"
#   }

# }
