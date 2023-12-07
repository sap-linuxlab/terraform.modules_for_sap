
# Create Block Storage for Intel Virtual Server
#
# Maximum 4 secondary data volumes per instance attached when creating an instance
# Maximum 12 secondary data volumes after instance exists

resource "ibm_is_volume" "block_volume_provision" {

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

  name           = "${var.module_var_virtual_server_hostname}-vol-${each.value.name}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = each.value.disk_type
  capacity       = each.value.disk_size
  iops           = each.value.disk_iops

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
