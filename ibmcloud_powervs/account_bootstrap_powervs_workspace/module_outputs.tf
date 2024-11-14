
output "output_power_guid" {
  value = ibm_pi_workspace.power.id
}

output "output_power_target_vpc_crn" {
  value = data.ibm_is_vpc.vpc.crn
}
