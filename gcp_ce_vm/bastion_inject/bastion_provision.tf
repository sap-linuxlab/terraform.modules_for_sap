
# Create Bastion/Jump host

resource "google_compute_instance" "bastion_host" {
  name         = "${var.module_var_resource_prefix}-bastion"
  machine_type = "e2-standard-2"
  zone         = var.module_var_gcp_region_zone

  boot_disk {
    auto_delete = true
    device_name = "${var.module_var_resource_prefix}-bastion-volume-boot"
    initialize_params {
      image = data.google_compute_image.bastion_os_image.self_link
      size  = 100
    }
  }

  network_interface {
    #    name       = "${var.module_var_resource_prefix}-bastion-nic0"
    subnetwork = google_compute_subnetwork.vpc_bastion_subnet.id
    nic_type   = "VIRTIO_NET" // Must use virtIO KVM NIC driver, Google Virtual NIC driver has unknown support for SAP workloads
    stack_type = "IPV4_ONLY"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin         = false                                                                     // Do not use GCP Project OS Login approach for SSH Keys
    block-project-ssh-keys = true                                                                      // Do not use GCP Project Metadata approach for SSH Keys
    ssh-keys               = "${var.module_var_bastion_user}:${var.module_var_bastion_public_ssh_key}" // Uses the GCP VM Instance Metadata approach for SSH Keys. Shows in GCP Console GUI under 'SSH Keys' for the VM Instance. Can not use 'root' because SSH 'PermitRootLogin' by default is 'no'.
  }

}
