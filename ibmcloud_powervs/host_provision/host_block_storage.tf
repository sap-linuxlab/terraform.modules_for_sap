
# Create Block Storage for IBM Power Virtual Server
#
# Types = tier1 (10 IOPS/GB), tier3 (3 IOPS/GB). See https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-about-virtual-server#storage-tiers

resource "ibm_pi_volume" "block_volume_provision" {
#  count = sum([ for storage_item in var.module_var_storage_definition: try(storage_item.disk_count,1) ])

  for_each = {
    for disk in flatten(
      [ for storage_item in var.module_var_storage_definition:
        [ for index, count in range(0,try(storage_item.disk_count,1)) :
          tomap({"name" = replace("${storage_item.name}-${index}","_","-"), "disk_type" = try(storage_item.disk_type, null), "disk_size" = storage_item.disk_size, "disk_iops" = try(storage_item.disk_iops,null)})
        ] if try(storage_item.swap_path,"") == ""
      ]
    ):
    disk.name => disk
  }

  pi_volume_name       = "${var.module_var_virtual_server_hostname}-vol-${each.value.name}"
  pi_volume_size       = each.value.disk_size
  pi_volume_type       = each.value.disk_type
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}
