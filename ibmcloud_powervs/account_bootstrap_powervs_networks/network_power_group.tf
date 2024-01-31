
# Create IBM Power Virtual Server Group Private Network Subnet
#
# Option 1. Specify the exact value of an IP address, for example 192.168.100.14/24
# Option 2. Specify a range of IP addresses, for example 192.168.100.0/22
# The CIDR will automatically generate the DNS Server, Gateway IP Address and IP Range for the Subnet
# DNS Server is default set to 127.0.0.1, and can add up to 20 DNS Servers


# Create IBM Power Virtual Server Group Private Network Subnet
resource "ibm_pi_network" "power_group_network_private" {
  pi_network_name      = "${var.module_var_resource_prefix}-power-group-network-private"
  pi_cloud_instance_id = var.module_var_ibmcloud_powervs_workspace_guid // Also shown by running either > ibmcloud resource service-instances --long  or  ibmcloud pi service-list
  pi_network_type      = "vlan"
  pi_cidr              = "192.168.0.32/27"
  pi_dns               = ["127.0.0.1"]
}


# Sleep to ensure instance is ready
resource "null_resource" "sleep_temp_network" {
  depends_on = [ibm_pi_network.power_group_network_private]
  provisioner "local-exec" {
    command = "echo '----Sleep 120s to ensure power networks are established-----' && sleep 120"
  }
}


# Create IBM Power Virtual Server Group Private Network Subnet for Management networking
resource "ibm_pi_network" "power_group_network_mgmt" {
  depends_on = [
    ibm_pi_network.power_group_network_private
  ]
  pi_network_name      = "${var.module_var_resource_prefix}-power-group-network-mgmt"
  pi_cloud_instance_id = var.module_var_ibmcloud_powervs_workspace_guid // Also shown by running either > ibmcloud resource service-instances --long  or  ibmcloud pi service-list
  pi_network_type      = "vlan"
  pi_cidr              = "192.168.0.0/27"
  pi_dns               = ["127.0.0.1"]
}

# Create IBM Power Virtual Server Group Public Network Subnet
#resource "ibm_pi_network" "power_group_network_public" {
#  depends_on = [
#    null_resource.sleep_temp,
#    ibm_pi_network.power_group_network_mgmt,
#    ibm_pi_network.power_group_network_private
#  ]
#
#  pi_network_name      = "${var.module_var_resource_prefix}-power-group-network-public"
#  pi_cloud_instance_id = var.module_var_ibmcloud_powervs_workspace_guid   // Also shown by running either > ibmcloud resource service-instances --long  or  ibmcloud pi service-list
#  pi_network_type      = "pub-vlan"
#}
