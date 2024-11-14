
# Create IBM Power Virtual Server Private Network Subnet
#
# Option 1. Specify the exact value of an IP address, for example 192.168.100.14/24
# Option 2. Specify a range of IP addresses, for example 192.168.100.0/22

# DNS Server is default set to IBM Cloud IaaS Backbone DNS Resolver 161.26.0.10/11
# as only 1 entry is permitted by the Terraform. The configured host will also include
# IBM Cloud Private DNS service defaults 161.26.0.7/8.
# Previously IBM Power VS default DNS was 127.0.0.1


# Create IBM Power Virtual Server Private Network Subnet
resource "ibm_pi_network" "power_network_private" {
  provider             = ibm.powervs_secure_enclave
  pi_network_name      = "${var.module_var_resource_prefix}-power-network-private"
  pi_cloud_instance_id = var.module_var_ibmcloud_powervs_workspace_guid // Also shown by running either > ibmcloud resource service-instances --long  or  ibmcloud pi service-list
  pi_network_type      = "vlan"
  pi_cidr              = "192.168.0.32/27"
  pi_dns               = ["161.26.0.10"]

  # Terraform only accepts 1 entry but API allows multiple, which may
  # cause resource to be updated in-place and cascade force replacements
  # when Terraform re-apply/re-calculate
  lifecycle {
    ignore_changes = [
      pi_dns
    ]
  }
}


# Sleep to ensure instance is ready
resource "null_resource" "sleep_temp_network" {
  depends_on = [ibm_pi_network.power_network_private]
  provisioner "local-exec" {
    command = "echo '----Sleep 120s to ensure power networks are established-----' && sleep 120"
  }
}


# Create IBM Power Virtual Server Private Network Subnet for Management networking
resource "ibm_pi_network" "power_network_mgmt" {
  depends_on = [
    ibm_pi_network.power_network_private
  ]
  provider             = ibm.powervs_secure_enclave
  pi_network_name      = "${var.module_var_resource_prefix}-power-network-mgmt"
  pi_cloud_instance_id = var.module_var_ibmcloud_powervs_workspace_guid // Also shown by running either > ibmcloud resource service-instances --long  or  ibmcloud pi service-list
  pi_network_type      = "vlan"
  pi_cidr              = "192.168.0.0/27"
  pi_dns               = ["161.26.0.10"]

  lifecycle {
    ignore_changes = [
      pi_dns
    ]
  }
}

# Create IBM Power Virtual Server Public Network Subnet
#resource "ibm_pi_network" "power_network_public" {
#  depends_on = [
#    null_resource.sleep_temp,
#    ibm_pi_network.power_network_mgmt,
#    ibm_pi_network.power_network_private
#  ]
#  provider             = ibm.powervs_secure_enclave
#  pi_network_name      = "${var.module_var_resource_prefix}-power-network-public"
#  pi_cloud_instance_id = var.module_var_ibmcloud_powervs_workspace_guid   // Also shown by running either > ibmcloud resource service-instances --long  or  ibmcloud pi service-list
#  pi_network_type      = "pub-vlan"
#}
