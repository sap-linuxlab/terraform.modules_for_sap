
# Create new host

resource "google_compute_instance" "host" {
  name         = var.module_var_virtual_machine_hostname
  machine_type = var.module_var_virtual_machine_profile
  zone         = var.module_var_gcp_region_zone

  boot_disk {
    auto_delete = true
    device_name = "${var.module_var_virtual_machine_hostname}-volume-boot"
    initialize_params {
      image = data.google_compute_image.host_os_image.self_link
      size  = 100
    }
  }

  can_ip_forward = var.module_var_disable_ip_anti_spoofing // When disable the Anti IP Spoofing = true, then Can IP Forward = true

  network_interface {
#    name       = "${var.module_var_resource_prefix}-bastion-nic0"
    subnetwork = local.target_vpc_subnet_id
    nic_type   = "VIRTIO_NET" // Must use virtIO KVM NIC driver, Google Virtual NIC driver has unknown support for SAP workloads
    stack_type = "IPV4_ONLY"
  }

  metadata = {
    enable-oslogin = false // Do not use GCP Project OS Login approach for SSH Keys
    block-project-ssh-keys = true // Do not use GCP Project Metadata approach for SSH Keys
    ssh-keys = "admin:${var.module_var_host_ssh_public_key}" // Uses the GCP VM Instance Metadata approach for SSH Keys. Shows in GCP Console GUI under 'SSH Keys' for the VM Instance. Can not use 'root' because SSH 'PermitRootLogin' by default is 'no'.
  }

  lifecycle {
    ignore_changes = [
      attached_disk // Ignore, as google_compute_attached_disk Terraform Resource force this to null each time
    ]
  }

}



# Attach GCP Zonal Persistent Disk block storage volumes to host

resource "google_compute_attached_disk" "volume_attachment" {
#  count    = length(google_compute_disk.block_volume.*.id)
  for_each = google_compute_disk.block_volume

  disk     = each.value.id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}
