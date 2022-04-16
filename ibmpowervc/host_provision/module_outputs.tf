
output "output_host_private_ip" {
  value = openstack_compute_instance_v2.host_provision.access_ip_v4
}

output "output_host_name" {
  value = openstack_compute_instance_v2.host_provision.name
}
