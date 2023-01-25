
# To enable the dynamic block for disks attachment to the VMware Virtual Machine, must use count on each Virtual Disk
# When using count = 1, the Virtual Disk is returned as a set. Without count it is returned as an object and will fail the for loop on the dynamic block

resource "vsphere_virtual_disk" "virtual_disk_hana_data" {
  count              = var.module_var_disk_volume_count_hana_data
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-hana-data${count.index}.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_hana_data
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}


resource "vsphere_virtual_disk" "virtual_disk_hana_log" {
  count              = var.module_var_disk_volume_count_hana_log
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-hana-log${count.index}.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_hana_log
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}


resource "vsphere_virtual_disk" "virtual_disk_hana_shared" {
  count              = var.module_var_disk_volume_count_hana_shared
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-hana-shared${count.index}.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_hana_shared
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}


resource "vsphere_virtual_disk" "virtual_disk_anydb" {
  count              = var.module_var_disk_volume_count_anydb
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-anydb${count.index}.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_anydb
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}


resource "vsphere_virtual_disk" "virtual_disk_usr_sap" {
  count              = var.module_var_disk_volume_count_usr_sap // Must be no more than 1
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-usr-sap${count.index}.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_usr_sap
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}


resource "vsphere_virtual_disk" "virtual_disk_sapmnt" {
  count              = var.module_var_disk_volume_count_sapmnt // Must be no more than 1
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-sapmnt.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_sapmnt
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}


resource "vsphere_virtual_disk" "virtual_disk_swap" {
  count              = var.module_var_disk_volume_count_swap // Must be no more than 1
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-swap.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_swap
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}


resource "vsphere_virtual_disk" "virtual_disk_software" {
  count              = 1 // Must be no more than 1
  datacenter         = data.vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  vmdk_path          = "/${var.module_var_vmware_vm_hostname}_data/${var.module_var_vmware_vm_hostname}-software.vmdk"
  create_directories = true

  size               = var.module_var_disk_volume_capacity_software
  type               = "lazy" # Thick Provision Lazy Zeroed (allocate then zero on first write)

  lifecycle {
    ignore_changes = [
      type
    ]
  }

}
