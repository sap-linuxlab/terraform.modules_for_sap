
output "output_power_group_guid" {
  value = ibm_resource_instance.power_group.guid
}

output "output_power_group_networks" {
  value = compact([
    ibm_pi_network.power_group_network_private.network_id,
    ibm_pi_network.power_group_network_mgmt.network_id
  ])
}

output "output_power_group_network_private_subnet" {
  value = ibm_pi_network.power_group_network_private.pi_cidr
}
