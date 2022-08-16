
# Create Block Storage

resource "azurerm_managed_disk" "block_volume_hana_data_voltype" {
  count = var.module_var_disk_volume_type_hana_data != "custom" ? var.module_var_disk_volume_count_hana_data : 0

  name                 = "${var.module_var_host_name}-volume-hana-data-${count.index}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  tier                 = var.module_var_disk_volume_type_hana_data
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_hana_data

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "azurerm_managed_disk" "block_volume_hana_log_voltype" {
  count = var.module_var_disk_volume_type_hana_log != "custom" ? var.module_var_disk_volume_count_hana_log : 0

  name                 = "${var.module_var_host_name}-volume-hana-log-${count.index}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  tier                 = var.module_var_disk_volume_type_hana_log
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_hana_log

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "azurerm_managed_disk" "block_volume_hana_shared_voltype" {
  count = var.module_var_disk_volume_type_hana_shared != "custom" ? var.module_var_disk_volume_count_hana_shared : 0

  name                 = "${var.module_var_host_name}-volume-hana-shared-${count.index}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  tier                 = var.module_var_disk_volume_type_hana_shared
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_hana_shared

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "azurerm_managed_disk" "block_volume_anydb" {
  count = var.module_var_disk_volume_type_anydb != "custom" ? var.module_var_disk_volume_count_anydb : 0

  name                 = "${var.module_var_host_name}-volume-anydb-${count.index}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  tier                 = var.module_var_disk_volume_type_anydb
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_anydb

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "azurerm_managed_disk" "block_volume_usr_sap_voltype" {
  count = var.module_var_disk_volume_count_usr_sap

  name                 = "${var.module_var_host_name}-volume-usr-sap-${count.index}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  tier                 = var.module_var_disk_volume_type_usr_sap
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_usr_sap

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "azurerm_managed_disk" "block_volume_sapmnt_voltype" {
  count = var.module_var_disk_volume_count_sapmnt

  name                 = "${var.module_var_host_name}-volume-sapmnt-${count.index}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  tier                 = var.module_var_disk_volume_type_sapmnt
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_sapmnt

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "azurerm_managed_disk" "block_volume_swap_voltype" {
  count = var.module_var_disk_volume_count_swap

  name                 = "${var.module_var_host_name}-volume-swap-${count.index}"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  tier                 = var.module_var_disk_volume_type_swap
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_swap

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


resource "azurerm_managed_disk" "block_volume_software_voltype" {

  name                 = "${var.module_var_host_name}-volume-software"
  resource_group_name  = local.target_resource_group_name
  location             = var.module_var_az_region
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.module_var_disk_volume_capacity_software

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}
