
variable "module_var_az_resource_group_name" {}

variable "module_var_az_region" {} // aka. Azure Location Display Name

variable "module_var_az_availability_zone_no" {}

variable "module_var_resource_prefix" {}

variable "module_var_az_vnet_name" {}

variable "module_var_az_vnet_subnet_name" {}

variable "module_var_bastion_private_ssh_key" {}

variable "module_var_bastion_user" {}

variable "module_var_bastion_ssh_port" {
  type = number
}

variable "module_var_host_os_image" {}

variable "module_var_host_name" {}


variable "module_var_host_ssh_key_id" {}

variable "module_var_host_ssh_public_key" {}

variable "module_var_host_ssh_private_key" {}

variable "module_var_host_sg_id" {}


variable "module_var_bastion_ip" {}

variable "module_var_bastion_connection_sg_id" {}



variable "module_var_az_vm_instance" {}


variable "module_var_disk_volume_type_hana_data" {}
variable "module_var_disk_volume_count_hana_data" {}
variable "module_var_disk_volume_capacity_hana_data" {}
variable "module_var_disk_volume_iops_hana_data" {
  default = null
}
variable "module_var_lvm_enable_hana_data" {}
variable "module_var_lvm_pv_data_alignment_hana_data" {
  default = "1M"
}
variable "module_var_lvm_vg_data_alignment_hana_data" {
  default = "1M"
}
variable "module_var_lvm_vg_physical_extent_size_hana_data" {
  default = "4M"
}
variable "module_var_lvm_lv_stripe_size_hana_data" {
  default = "64K"
}
variable "module_var_filesystem_hana_data" {
  default = "xfs"
}
variable "module_var_physical_partition_filesystem_block_size_hana_data" {}


variable "module_var_disk_volume_type_hana_log" {}
variable "module_var_disk_volume_count_hana_log" {}
variable "module_var_disk_volume_capacity_hana_log" {}
variable "module_var_disk_volume_iops_hana_log" {
  default = null
}
variable "module_var_lvm_enable_hana_log" {}
variable "module_var_lvm_pv_data_alignment_hana_log" {
  default = "1M"
}
variable "module_var_lvm_vg_data_alignment_hana_log" {
  default = "1M"
}
variable "module_var_lvm_vg_physical_extent_size_hana_log" {
  default = "4M"
}
variable "module_var_lvm_lv_stripe_size_hana_log" {
  default = "64K"
}
variable "module_var_filesystem_hana_log" {
  default = "xfs"
}
variable "module_var_physical_partition_filesystem_block_size_hana_log" {}


variable "module_var_disk_volume_type_hana_shared" {}
variable "module_var_disk_volume_count_hana_shared" {}
variable "module_var_disk_volume_capacity_hana_shared" {}
variable "module_var_disk_volume_iops_hana_shared" {
  default = null
}
variable "module_var_lvm_enable_hana_shared" {}
variable "module_var_lvm_pv_data_alignment_hana_shared" {
  default = "1M"
}
variable "module_var_lvm_vg_data_alignment_hana_shared" {
  default = "1M"
}
variable "module_var_lvm_vg_physical_extent_size_hana_shared" {
  default = "4M"
}
variable "module_var_lvm_lv_stripe_size_hana_shared" {
  default = "64K"
}
variable "module_var_filesystem_hana_shared" {
  default = "xfs"
}
variable "module_var_physical_partition_filesystem_block_size_hana_shared" {}


variable "module_var_disk_volume_count_usr_sap" {}
variable "module_var_disk_volume_type_usr_sap" {}
variable "module_var_disk_volume_capacity_usr_sap" {}
variable "module_var_filesystem_usr_sap" {
  default = "xfs"
}


variable "module_var_disk_volume_count_sapmnt" {}
variable "module_var_disk_volume_type_sapmnt" {}
variable "module_var_disk_volume_capacity_sapmnt" {}
variable "module_var_filesystem_sapmnt" {
  default = "xfs"
}


variable "module_var_disk_swapfile_size_gb" {}
variable "module_var_disk_volume_count_swap" {}
variable "module_var_disk_volume_type_swap" {}
variable "module_var_disk_volume_capacity_swap" {}
variable "module_var_filesystem_swap" {
  default = "xfs"
}


variable "module_var_sap_software_download_directory" {
  default = "/software"
}
variable "module_var_disk_volume_capacity_software" {
  default = 525
}

variable "module_var_dns_zone_name" {}

variable "module_var_dns_root_domain_name" {}
