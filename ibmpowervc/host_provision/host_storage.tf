
# Create IBM PowerVC Data Volumes
# https://www.ibm.com/docs/en/powervc/1.4.3?topic=apis-supported-volume-type-extra-specs

resource "openstack_blockstorage_volume_v2" "block_volume_provision" {

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

  name        = "${var.module_var_lpar_hostname}-vol-${each.value.name}"
  size        = each.value.disk_size
  volume_type = each.value.disk_type
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}
