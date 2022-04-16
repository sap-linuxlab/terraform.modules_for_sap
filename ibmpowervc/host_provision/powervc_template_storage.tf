
# Show IBM PowerVC Storage list
# openstack --insecure volume service list --service cinder-volume

# Show IBM PowerVC Storage Template list
# openstack --insecure volume type list


# Create IBM PowerVC Storage Template
# https://www.ibm.com/docs/en/powervc/1.4.3?topic=apis-supported-volume-type-extra-specs

resource "openstack_blockstorage_volume_type_v3" "ibm_storwize_storage_template_sap_hana_fast" {
  name        = "${var.module_var_resource_prefix}-storage-template-sap_hana_fast" // IBM PowerVC Storage Template name
  description = "Storage for SAP HANA which is fastest, and used for /hana/data and /hana/log"
  is_public   = true
  extra_specs = {
    "drivers:display_name" : "${var.module_var_resource_prefix}-storage-template-sap_hana_fast" // Unused, kept same as Storage Template name for posterity
    "capabilities:volume_backend_name" : var.module_var_ibmpowervc_storage_storwize_hostname_short
    "drivers:storage_pool" : var.module_var_ibmpowervc_storage_storwize_storage_pool_flash
    #"qos:IOThrottling_unit": "iops_per_gb" // iops, iops_per_gb, mbps
    #"qos:IOThrottling": 10
    "drivers:match_init_pg" : "false"
    "drivers:compression" : "0"
    "drivers:grainsize" : "256" // Thin-provisioning, grain size (KB)
    "drivers:rsize" : "2"       // Thin-provisioning, % of real capacity
    "drivers:autoexpand" : "1"
    "drivers:warning" : "0"
    #"drivers:iogrp": "0" // Can provision without being set, however this is required when using IBM PowerVC GUI
    "drivers:mirror_pool" : null
    "drivers:multipath" : "False"
    "drivers:flashcopy_rate" : "50"
    "drivers:nofmtdisk" : "0"
  }
}


resource "openstack_blockstorage_volume_type_v3" "ibm_storwize_storage_template_sap_other" {
  name        = "${var.module_var_resource_prefix}-storage-template-sap_other" // IBM PowerVC Storage Template name
  description = "Storage for all other mount points of the SAP hosts"
  is_public   = true
  extra_specs = {
    "drivers:display_name" : "${var.module_var_resource_prefix}-storage-template-sap_other" // Unused, kept same as Storage Template name for posterity
    "capabilities:volume_backend_name" : var.module_var_ibmpowervc_storage_storwize_hostname_short
    "drivers:storage_pool" : var.module_var_ibmpowervc_storage_storwize_storage_pool
    "qos:IOThrottling_unit" : "iops_per_gb" // iops, iops_per_gb, mbps
    "qos:IOThrottling" : 10
    "drivers:match_init_pg" : "false"
    "drivers:compression" : "0"
    "drivers:grainsize" : "256" // Thin-provisioning, grain size (KB)
    "drivers:rsize" : "2"       // Thin-provisioning, % of real capacity
    "drivers:autoexpand" : "1"
    "drivers:warning" : "0"
    #"drivers:iogrp": "0" // Can provision without being set, however this is required when using IBM PowerVC GUI
    "drivers:mirror_pool" : null
    "drivers:multipath" : "False"
    "drivers:flashcopy_rate" : "50"
    "drivers:nofmtdisk" : "0"
  }
}


locals {
  ibm_storwize_storage_template_sap_hana_fast_name = openstack_blockstorage_volume_type_v3.ibm_storwize_storage_template_sap_hana_fast.name
  ibm_storwize_storage_template_sap_other_name     = openstack_blockstorage_volume_type_v3.ibm_storwize_storage_template_sap_other.name
  #ibm_storwize_storage_template_sap_other_name = lookup(openstack_blockstorage_volume_type_v3.ibm_storwize_storage_template_sap_other.extra_specs, "drivers:display_name", null)
  #ibm_storwize_storage_template_sap_other_name = lookup({for key, value in openstack_blockstorage_volume_type_v3.ibm_storwize_storage_template_sap_other.extra_specs: key => value}, "drivers:display_name", "test")
  #ibm_storwize_storage_template_sap_other_name = lookup({for key, value in openstack_blockstorage_volume_type_v3.ibm_storwize_storage_template_sap_other.extra_specs: key => value if key == "drivers:display_name"}, "drivers:display_name", "test")
}
