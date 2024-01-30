
# Create Block Storage

resource "azurerm_managed_disk" "block_volume" {
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

  name                 = "${var.module_var_host_name}-vol-${each.value.name}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_location_region

  // Premium SSD size (P), Standard SSD size (E), Standard HDD size (S)
  storage_account_type = can(regex("^P.*", try(each.value.disk_type, null))) ? "Premium_LRS" : can(regex("^E.*", try(each.value.disk_type, null))) ? "StandardSSD_LRS" : can(regex("^S.*", try(each.value.disk_type, null))) ? "Standard_LRS" : "error"
  tier                 = can(regex("^[P].*",try(each.value.disk_type, null))) ? try(each.value.disk_type, null) : null
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size

  disk_iops_read_write = each.value.disk_iops

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
