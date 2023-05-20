
# Create Block Storage

# pd-standard, Standard persistent disks
# pd-balanced, Balanced persistent disks
# pd-ssd, Performance (SSD) persistent disks
# pd-extreme, Extreme persistent disks

resource "google_compute_disk" "block_volume" {
#  count = sum([ for storage_item in var.module_var_storage_definition: try(storage_item.disk_count,1) ])

  for_each = {
    for disk in flatten(
      [ for storage_item in var.module_var_storage_definition:
        [ for index, count in range(0,try(storage_item.disk_count,1)) :
          tomap({"name" = replace("${storage_item.name}-${index}","_","-"), "disk_type" = try(storage_item.disk_type, null), "disk_size" = storage_item.disk_size, "disk_iops" = try(storage_item.disk_iops,null)})
        ]
      ]
    ):
    disk.name => disk
  }

  zone                      = var.module_var_gcp_region_zone
  name                      = "${var.module_var_virtual_machine_hostname}-vol-${each.value.name}"
  type                      = each.value.disk_type
  size                      = each.value.disk_size
  physical_block_size_bytes = 4096
#  interface                 = "SCSI"
  provisioned_iops          = each.value.disk_iops
}
