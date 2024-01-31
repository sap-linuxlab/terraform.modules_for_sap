
output "output_power_group_guid" {
  value = ibm_resource_instance.power_group.guid
}

output "output_power_target_vpc_crn" {
  value = data.ibm_is_vpc.vpc.crn
}
