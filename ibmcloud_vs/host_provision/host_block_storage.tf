
# Create Block Storage for Intel Virtual Server
#
# Maximum 4 secondary data volumes per instance attached when creating an instance
# Maximum 12 secondary data volumes after instance exists

resource "ibm_is_volume" "block_volume_hana_data_tiered" {
  count = var.module_var_disk_volume_type_hana_data != "custom" ? var.module_var_disk_volume_count_hana_data : 0

  name           = "${var.module_var_virtual_server_hostname}-volume-hana-data-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_hana_data
  capacity       = var.module_var_disk_volume_capacity_hana_data
}

resource "ibm_is_volume" "block_volume_hana_data_custom" {
  count = var.module_var_disk_volume_type_hana_data == "custom" ? var.module_var_disk_volume_count_hana_data : 0

  name           = "${var.module_var_virtual_server_hostname}-volume-hana-data-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_hana_data
  capacity       = var.module_var_disk_volume_capacity_hana_data
  iops           = var.module_var_disk_volume_iops_hana_data
}



resource "ibm_is_volume" "block_volume_hana_log_tiered" {
  count = var.module_var_disk_volume_type_hana_log != "custom" ? var.module_var_disk_volume_count_hana_log : 0

  name           = "${var.module_var_virtual_server_hostname}-volume-hana-log-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_hana_log
  capacity       = var.module_var_disk_volume_capacity_hana_log
}

resource "ibm_is_volume" "block_volume_hana_log_custom" {
  count = var.module_var_disk_volume_type_hana_log == "custom" ? var.module_var_disk_volume_count_hana_log : 0

  name           = "${var.module_var_virtual_server_hostname}-volume-hana-log-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_hana_log
  capacity       = var.module_var_disk_volume_capacity_hana_log
  iops           = var.module_var_disk_volume_iops_hana_log
}



resource "ibm_is_volume" "block_volume_hana_shared_tiered" {
  count = var.module_var_disk_volume_type_hana_shared != "custom" ? var.module_var_disk_volume_count_hana_shared : 0

  name           = "${var.module_var_virtual_server_hostname}-volume-hana-shared-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_hana_shared
  capacity       = var.module_var_disk_volume_capacity_hana_shared
}

resource "ibm_is_volume" "block_volume_hana_shared_custom" {
  count = var.module_var_disk_volume_type_hana_shared == "custom" ? var.module_var_disk_volume_count_hana_shared : 0

  name           = "${var.module_var_virtual_server_hostname}-volume-hana-shared-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_hana_shared
  capacity       = var.module_var_disk_volume_capacity_hana_shared
  iops           = var.module_var_disk_volume_iops_hana_shared
}



resource "ibm_is_volume" "block_volume_usr_sap_tiered" {
  count = var.module_var_disk_volume_count_usr_sap

  name           = "${var.module_var_virtual_server_hostname}-volume-usr-sap-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_usr_sap
  capacity       = var.module_var_disk_volume_capacity_usr_sap
}

resource "ibm_is_volume" "block_volume_sapmnt_tiered" {
  count = var.module_var_disk_volume_count_sapmnt

  name           = "${var.module_var_virtual_server_hostname}-volume-sapmnt-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_sapmnt
  capacity       = var.module_var_disk_volume_capacity_sapmnt
}

resource "ibm_is_volume" "block_volume_swap_tiered" {
  count = var.module_var_disk_volume_count_swap

  name           = "${var.module_var_virtual_server_hostname}-volume-swap-${count.index}"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_swap
  capacity       = var.module_var_disk_volume_capacity_swap
}

resource "ibm_is_volume" "block_volume_software_tiered" {

  name           = "${var.module_var_virtual_server_hostname}-volume-software-0"
  resource_group = var.module_var_resource_group_id
  zone           = local.target_vpc_availability_zone
  profile        = var.module_var_disk_volume_type_software
  capacity       = var.module_var_disk_volume_capacity_software
}
