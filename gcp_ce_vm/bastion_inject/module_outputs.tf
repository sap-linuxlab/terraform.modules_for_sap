
output "output_bastion_subnet_name" {
  value = google_compute_subnetwork.vpc_bastion_subnet.name
}

output "output_bastion_ip" {
  value = google_compute_instance.bastion_host.network_interface[0].access_config[0].nat_ip
}
