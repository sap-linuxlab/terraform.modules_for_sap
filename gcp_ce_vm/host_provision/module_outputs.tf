
output "output_host_private_ip" {
  value = google_compute_instance.host.network_interface[0].network_ip
}

output "output_host_name" {
  value = var.module_var_virtual_machine_hostname
}
