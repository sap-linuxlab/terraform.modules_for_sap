
data "vsphere_datacenter" "datacenter" {
  name = var.module_var_vmware_vsphere_datacenter_name
}


data "vsphere_compute_cluster" "cluster" {
  name          = var.module_var_vmware_vsphere_datacenter_compute_cluster_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_host" "host" {
  name          = var.module_var_vmware_vsphere_datacenter_compute_cluster_host_fqdn
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


# Select VM and Template Folder
data "vsphere_folder" "folder" {
  path = var.module_var_vmware_vsphere_datacenter_compute_cluster_folder_name
}


data "vsphere_datastore" "datastore" {
  name          = var.module_var_vmware_vsphere_datacenter_storage_datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_network" "network" {
  name          = var.module_var_vmware_vsphere_datacenter_network_primary_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_virtual_machine" "provision_template" {
  name          = "${var.module_var_vmware_vsphere_datacenter_compute_cluster_folder_name}/${var.module_var_vmware_vm_template_name}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
