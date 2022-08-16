variable "module_var_resource_prefix" {
}

variable "module_var_ibmpowervc_host_group_name" {
}

variable "module_var_ibmpowervc_network_name" {
}

variable "module_var_ibmpowervc_compute_cpu_threads" {
}

variable "module_var_ibmpowervc_compute_ram_gb" {
}

variable "module_var_ibmpowervc_os_image_name" {
}

variable "module_var_host_ssh_key_name" {
}

variable "module_var_host_public_ssh_key" {
}

variable "module_var_host_private_ssh_key" {
}


variable "module_var_ibmpowervc_template_compute_name" {
}

variable "module_var_ibmpowervc_template_compute_name_create_boolean" {
}

variable "module_var_ibmpowervc_storage_storwize_hostname_short" {
}

variable "module_var_ibmpowervc_storage_storwize_storage_pool" {
}

variable "module_var_ibmpowervc_storage_storwize_storage_pool_flash" {
}


variable "module_var_lpar_hostname" {
  validation {
    condition     = length(var.module_var_lpar_hostname) <= 13
    error_message = "Hostname must be equal to or lower than 13 characters in length."
  }
}

variable "module_var_dns_root_domain_name" {
}

variable "module_var_disk_volume_count_hana_data" {}
variable "module_var_disk_volume_capacity_hana_data" {}
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



variable "module_var_disk_volume_count_hana_log" {}
variable "module_var_disk_volume_capacity_hana_log" {}
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


variable "module_var_disk_volume_count_hana_shared" {}
variable "module_var_disk_volume_capacity_hana_shared" {}
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

variable "module_var_disk_volume_type_anydb" {}
variable "module_var_disk_volume_count_anydb" {}
variable "module_var_disk_volume_capacity_anydb" {}
variable "module_var_disk_volume_iops_anydb" {
  default = null
}
variable "module_var_lvm_enable_anydb" {
  default = false
}
variable "module_var_lvm_pv_data_alignment_anydb" {
  default = "1M"
}
variable "module_var_lvm_vg_data_alignment_anydb" {
  default = "1M"
}
variable "module_var_lvm_vg_physical_extent_size_anydb" {
  default = "4M"
}
variable "module_var_lvm_lv_stripe_size_anydb" {
  default = "64K"
}
variable "module_var_filesystem_mount_path_anydb" {
}
variable "module_var_filesystem_anydb" {
  default = "xfs"
}
variable "module_var_physical_partition_filesystem_block_size_anydb" {
  default = "4k"
}


variable "module_var_disk_volume_count_usr_sap" {}
variable "module_var_disk_volume_capacity_usr_sap" {}
variable "module_var_filesystem_usr_sap" {
  default = "xfs"
}

variable "module_var_disk_volume_count_sapmnt" {}
variable "module_var_disk_volume_capacity_sapmnt" {}
variable "module_var_filesystem_sapmnt" {
  default = "xfs"
}

variable "module_var_disk_swapfile_size_gb" {}
variable "module_var_disk_volume_count_swap" {}
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

variable "module_var_web_proxy_url" {}
variable "module_var_web_proxy_exclusion" {}

variable "module_var_os_vendor_account_user" {}
variable "module_var_os_vendor_account_user_passcode" {}
variable "module_var_os_systems_mgmt_host" {
  default = ""
}
