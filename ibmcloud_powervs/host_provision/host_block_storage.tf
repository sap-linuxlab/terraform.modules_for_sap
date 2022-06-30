
# Create Block Storage for IBM Power Virtual Server
#
# Types = tier1 (10 IOPS/GB), tier3 (3 IOPS/GB). See https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-about-virtual-server#storage-tiers

resource "ibm_pi_volume" "block_volume_hana_data_tiered" {
  count = var.module_var_disk_volume_count_hana_data

  pi_volume_name       = "${var.module_var_virtual_server_hostname}-volume-hana-data-${count.index}"
  pi_volume_size       = var.module_var_disk_volume_capacity_hana_data
  pi_volume_type       = var.module_var_disk_volume_type_hana_data
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "ibm_pi_volume" "block_volume_hana_log_tiered" {
  count = var.module_var_disk_volume_count_hana_log

  pi_volume_name       = "${var.module_var_virtual_server_hostname}-volume-hana-log-${count.index}"
  pi_volume_size       = var.module_var_disk_volume_capacity_hana_log
  pi_volume_type       = var.module_var_disk_volume_type_hana_log
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "ibm_pi_volume" "block_volume_hana_shared_tiered" {
  count = var.module_var_disk_volume_count_hana_shared

  pi_volume_name       = "${var.module_var_virtual_server_hostname}-volume-hana-shared-${count.index}"
  pi_volume_size       = var.module_var_disk_volume_capacity_hana_shared
  pi_volume_type       = var.module_var_disk_volume_type_hana_shared
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "ibm_pi_volume" "block_volume_usr_sap_tiered" {
  count = var.module_var_disk_volume_count_usr_sap

  pi_volume_name       = "${var.module_var_virtual_server_hostname}-volume-hana-usr-sap-${count.index}"
  pi_volume_size       = var.module_var_disk_volume_capacity_usr_sap
  pi_volume_type       = var.module_var_disk_volume_type_usr_sap
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "ibm_pi_volume" "block_volume_sapmnt_tiered" {
  count = var.module_var_disk_volume_count_sapmnt

  pi_volume_name       = "${var.module_var_virtual_server_hostname}-volume-hana-sapmnt-${count.index}"
  pi_volume_size       = var.module_var_disk_volume_capacity_sapmnt
  pi_volume_type       = var.module_var_disk_volume_type_sapmnt
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "ibm_pi_volume" "block_volume_swap_tiered" {
  count = var.module_var_disk_volume_count_swap

  pi_volume_name       = "${var.module_var_virtual_server_hostname}-volume-hana-swap-${count.index}"
  pi_volume_size       = var.module_var_disk_volume_capacity_swap
  pi_volume_type       = var.module_var_disk_volume_type_swap
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "ibm_pi_volume" "block_volume_software_tiered" {
  pi_volume_name       = "${var.module_var_virtual_server_hostname}-volume-hana-software-0"
  pi_volume_size       = var.module_var_disk_volume_capacity_software
  pi_volume_type       = var.module_var_disk_volume_type_software
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.module_var_ibm_power_group_guid

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
