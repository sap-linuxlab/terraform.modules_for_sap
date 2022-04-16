
# Create IBM PowerVC Data Volumes
# https://www.ibm.com/docs/en/powervc/1.4.3?topic=apis-supported-volume-type-extra-specs

resource "openstack_blockstorage_volume_v2" "block_volume_hana_data" {
  count = var.module_var_disk_volume_count_hana_data

  name        = "${var.module_var_lpar_hostname}-volume-hana-data-${count.index}"
  size        = var.module_var_disk_volume_capacity_hana_data
  volume_type = local.ibm_storwize_storage_template_sap_hana_fast_name
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}


resource "openstack_blockstorage_volume_v2" "block_volume_hana_log" {
  count = var.module_var_disk_volume_count_hana_log

  name        = "${var.module_var_lpar_hostname}-volume-hana-log-${count.index}"
  size        = var.module_var_disk_volume_capacity_hana_log
  volume_type = local.ibm_storwize_storage_template_sap_hana_fast_name
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}


resource "openstack_blockstorage_volume_v2" "block_volume_hana_shared" {
  count = var.module_var_disk_volume_count_hana_shared

  name        = "${var.module_var_lpar_hostname}-volume-hana-shared-${count.index}"
  size        = var.module_var_disk_volume_capacity_hana_shared
  volume_type = local.ibm_storwize_storage_template_sap_other_name
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}


resource "openstack_blockstorage_volume_v2" "block_volume_usr_sap" {
  count = var.module_var_disk_volume_count_usr_sap

  name        = "${var.module_var_lpar_hostname}-volume-usr-sap-${count.index}"
  size        = var.module_var_disk_volume_capacity_usr_sap
  volume_type = local.ibm_storwize_storage_template_sap_other_name
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}


resource "openstack_blockstorage_volume_v2" "block_volume_sapmnt" {
  count = var.module_var_disk_volume_count_sapmnt

  name        = "${var.module_var_lpar_hostname}-volume-sapmnt-${count.index}"
  size        = var.module_var_disk_volume_capacity_sapmnt
  volume_type = local.ibm_storwize_storage_template_sap_other_name
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}


resource "openstack_blockstorage_volume_v2" "block_volume_swap" {
  count = var.module_var_disk_volume_count_swap

  name        = "${var.module_var_lpar_hostname}-volume-swap-${count.index}"
  size        = var.module_var_disk_volume_capacity_swap
  volume_type = local.ibm_storwize_storage_template_sap_other_name
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}


resource "openstack_blockstorage_volume_v2" "block_volume_software" {
  name        = "${var.module_var_lpar_hostname}-volume-software-0"
  size        = var.module_var_disk_volume_capacity_software
  volume_type = local.ibm_storwize_storage_template_sap_other_name
  #multiattach = true

  scheduler_hints {

    # After provisioning, modifications to extra_specs parameters may not be identified during Terraform refresh and re-apply
    additional_properties = {
      "drivers:multipath" : "0"
    }

  }

}
