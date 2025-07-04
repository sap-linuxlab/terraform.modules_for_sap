
# From the Stock OS Image, create a Boot Image for the IBM Power Virtual Server

resource "ibm_pi_image" "host_os_image" {
  provider             = ibm.powervs_secure_enclave
  pi_image_id          = local.target_catalog_os_image_id
  pi_cloud_instance_id = var.module_var_ibm_power_guid
}




# Create IBM Power Virtual Server, via SAP-certified profiles (pre-defined Memory and CPU)
# Designed for SAP HANA

resource "ibm_pi_instance" "host_via_certified_profile" {
  provider          = ibm.powervs_secure_enclave

  pi_instance_name  = var.module_var_virtual_server_hostname

  pi_sap_profile_id = var.module_var_virtual_server_profile // e.g. "ush1-4x256"
  pi_sys_type       = var.module_var_hardware_machine_type

  pi_image_id     = ibm_pi_image.host_os_image.image_id
  pi_storage_type = "tier1" // tier1 required for SAP-certified Profiles

  pi_key_pair_name     = ibm_pi_key.host_ssh.name
  pi_cloud_instance_id = var.module_var_ibm_power_guid
  pi_pin_policy        = "none"
  pi_health_status     = "OK"

  pi_network {
    network_id = var.module_var_power_networks[0]
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }
}


# Attach block disk volumes to host
resource "ibm_pi_volume_attach" "block_volume_attachment" {
  provider              = ibm.powervs_secure_enclave

  for_each              = ibm_pi_volume.block_volume_provision

  pi_cloud_instance_id  = var.module_var_ibm_power_guid
  pi_instance_id        = ibm_pi_instance.host_via_certified_profile.instance_id
  pi_volume_id          = each.value.volume_id
}


# Create IBM Power Virtual Server, via bespoke size (customisable Memory and CPU)
# Designed for SAP NetWeaver AS and SAP AnyDB, cannot use with SAP HANA

#resource "ibm_pi_instance" "host_via_certified_bespoke_size" {
#  provider              = ibm.powervs_secure_enclave
#
#  pi_instance_name      = var.module_var_virtual_server_hostname
#
#  pi_memory             = "32" //"256"
#  pi_processors         = "1" //"4"
#  pi_proc_type          = "shared"
#  pi_sys_type           = var.module_var_hardware_machine_type
#
#  pi_image_id           = ibm_pi_image.host_os_image.image_id
#  pi_storage_type       = "tier1" // If using with Stock OS Image, using tier 3 may cause error "failed to Create PVM Instance : failed to get stock image for storage type tier3"
#
#  pi_key_pair_name      = ibm_pi_key.host_ssh.key_id
#  pi_cloud_instance_id  = var.module_var_ibm_power_guid
#  pi_pin_policy         = "none"
#  pi_health_status      = "OK"
#
#  pi_network {
#    network_id = var.module_var_power_networks[0]
#  }
#
#  pi_volume_ids = flatten([
#    ibm_pi_volume.block_volume.*.volume_id
#  ])
#
#  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
#  timeouts {
#    create = "30m"
#    delete = "30m"
#  }
#}
