
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

resource "google_compute_attached_disk" "volume_attachment_hana_data" {
  count    = length(google_compute_disk.block_volume_hana_data_voltype.*.id)
  disk     = google_compute_disk.block_volume_hana_data_voltype[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_hana_data_custom" {
  count    = length(google_compute_disk.block_volume_hana_data_custom.*.id)
  disk     = google_compute_disk.block_volume_hana_data_custom[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_hana_log" {
  count    = length(google_compute_disk.block_volume_hana_log_voltype.*.id)
  disk     = google_compute_disk.block_volume_hana_log_voltype[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_hana_log_custom" {
  count    = length(google_compute_disk.block_volume_hana_log_custom.*.id)
  disk     = google_compute_disk.block_volume_hana_log_custom[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_hana_shared" {
  count    = length(google_compute_disk.block_volume_hana_shared_voltype.*.id)
  disk     = google_compute_disk.block_volume_hana_shared_voltype[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_hana_shared_custom" {
  count    = length(google_compute_disk.block_volume_hana_shared_custom.*.id)
  disk     = google_compute_disk.block_volume_hana_shared_custom[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_anydb" {
  count    = length(google_compute_disk.block_volume_anydb_voltype.*.id)
  disk     = google_compute_disk.block_volume_anydb_voltype[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_anydb_custom" {
  count    = length(google_compute_disk.block_volume_anydb_custom.*.id)
  disk     = google_compute_disk.block_volume_anydb_custom[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_usr_sap" {
  count    = length(google_compute_disk.block_volume_usr_sap_voltype.*.id)
  disk     = google_compute_disk.block_volume_usr_sap_voltype[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_sapmnt" {
  count    = length(google_compute_disk.block_volume_sapmnt_voltype.*.id)
  disk     = google_compute_disk.block_volume_sapmnt_voltype[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_swap" {
  count    = length(google_compute_disk.block_volume_swap_voltype.*.id)
  disk     = google_compute_disk.block_volume_swap_voltype[count.index].id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}

resource "google_compute_attached_disk" "volume_attachment_software" {
  disk     = google_compute_disk.block_volume_software_voltype.id
  instance = google_compute_instance.host.id
  mode     = "READ_WRITE"
}
