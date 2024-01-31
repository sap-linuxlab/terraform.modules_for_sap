
# To enable the dynamic block for disks attachment to the VMware Virtual Machine, must use count on each Virtual Disk
# When using count = 1, the Virtual Disk is returned as a set. Without count it is returned as an object and will fail the for loop on the dynamic block

resource "vsphere_virtual_disk" "virtual_disk_provision" {

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

  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-${each.value.name}.vmdk"
  create_directories = true

  size               = each.value.disk_size
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}
