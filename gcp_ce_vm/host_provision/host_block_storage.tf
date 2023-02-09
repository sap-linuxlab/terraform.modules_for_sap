
# Create Block Storage

# pd-standard, Standard persistent disks
# pd-balanced, Balanced persistent disks
# pd-ssd, Performance (SSD) persistent disks
# pd-extreme, Extreme persistent disks


resource "google_compute_disk" "block_volume_hana_data_voltype" {
  count = var.module_var_disk_volume_type_hana_data != "custom" ? var.module_var_disk_volume_count_hana_data : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-hana-data-${count.index}"
  type                      = var.module_var_disk_volume_type_hana_data
  size                      = var.module_var_disk_volume_capacity_hana_data
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}

resource "google_compute_disk" "block_volume_hana_data_custom" {
  count = var.module_var_disk_volume_type_hana_data == "custom" ? var.module_var_disk_volume_count_hana_data : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-hana-data-${count.index}"
  type                      = var.module_var_disk_volume_type_hana_data
  size                      = var.module_var_disk_volume_capacity_hana_data
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
  provisioned_iops          = var.module_var_disk_volume_iops_hana_data
}



resource "google_compute_disk" "block_volume_hana_log_voltype" {
  count = var.module_var_disk_volume_type_hana_log != "custom" ? var.module_var_disk_volume_count_hana_log : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-hana-log-${count.index}"
  type                      = var.module_var_disk_volume_type_hana_log
  size                      = var.module_var_disk_volume_capacity_hana_log
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}

resource "google_compute_disk" "block_volume_hana_log_custom" {
  count = var.module_var_disk_volume_type_hana_log == "custom" ? var.module_var_disk_volume_count_hana_log : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-hana-log-${count.index}"
  type                      = var.module_var_disk_volume_type_hana_log
  size                      = var.module_var_disk_volume_capacity_hana_log
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
  provisioned_iops          = var.module_var_disk_volume_iops_hana_log
}



resource "google_compute_disk" "block_volume_hana_shared_voltype" {
  count = var.module_var_disk_volume_type_hana_shared != "custom" ? var.module_var_disk_volume_count_hana_shared : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-hana-shared-${count.index}"
  type                      = var.module_var_disk_volume_type_hana_shared
  size                      = var.module_var_disk_volume_capacity_hana_shared
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}

resource "google_compute_disk" "block_volume_hana_shared_custom" {
  count = var.module_var_disk_volume_type_hana_shared == "custom" ? var.module_var_disk_volume_count_hana_shared : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-hana-shared-${count.index}"
  type                      = var.module_var_disk_volume_type_hana_shared
  size                      = var.module_var_disk_volume_capacity_hana_shared
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
  provisioned_iops          = var.module_var_disk_volume_iops_hana_shared
}



resource "google_compute_disk" "block_volume_anydb_voltype" {
  count = var.module_var_disk_volume_type_anydb != "custom" ? var.module_var_disk_volume_count_anydb : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-anydb-${count.index}"
  type                      = var.module_var_disk_volume_type_anydb
  size                      = var.module_var_disk_volume_capacity_anydb
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}

resource "google_compute_disk" "block_volume_anydb_custom" {
  count = var.module_var_disk_volume_type_anydb == "custom" ? var.module_var_disk_volume_count_anydb : 0

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-anydb-${count.index}"
  type                      = var.module_var_disk_volume_type_anydb
  size                      = var.module_var_disk_volume_capacity_anydb
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
  provisioned_iops          = var.module_var_disk_volume_iops_anydb
}



resource "google_compute_disk" "block_volume_usr_sap_voltype" {
  count = var.module_var_disk_volume_count_usr_sap

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-usr-sap-${count.index}"
  type                      = var.module_var_disk_volume_type_usr_sap
  size                      = var.module_var_disk_volume_capacity_usr_sap
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}

resource "google_compute_disk" "block_volume_sapmnt_voltype" {
  count = var.module_var_disk_volume_count_sapmnt

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-sapmnt-${count.index}"
  type                      = var.module_var_disk_volume_type_sapmnt
  size                      = var.module_var_disk_volume_capacity_sapmnt
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}

resource "google_compute_disk" "block_volume_swap_voltype" {
  count = var.module_var_disk_volume_count_swap

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-swap-${count.index}"
  type                      = var.module_var_disk_volume_type_swap
  size                      = var.module_var_disk_volume_capacity_swap
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}

resource "google_compute_disk" "block_volume_software_voltype" {
  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-volume-software"
  type                      = var.module_var_disk_volume_type_software
  size                      = var.module_var_disk_volume_capacity_software
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
}
