
output "output_host_name" {
  value = ibm_pi_instance.host_via_certified_profile.pi_instance_name
}

output "output_host_private_ip" {
  value = ibm_pi_instance.host_via_certified_profile.pi_network[0].ip_address
}
