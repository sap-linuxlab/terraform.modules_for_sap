
# Create Intel Virtual Server

resource "ibm_is_instance" "virtual_server" {

  resource_group = var.module_var_resource_group_id
  name           = var.module_var_virtual_server_hostname
  profile        = var.module_var_virtual_server_profile

  vpc   = local.target_vpc_id
  zone  = local.target_vpc_availability_zone
  image = data.ibm_is_image.host_os_image.id // Must use Image ID
  keys  = [var.module_var_host_ssh_key_id]

  # The Subnet assigned to the Primary Network  (vNIC) cannot be changed
  # The Name and Security Group assigned to the Primary Network Interface (vNIC) are editable
  # Each Network Interface has a network performance cap of 16 Gbps; this is separate to the network performance cap increment of 2GBps per vCPU
  primary_network_interface {
    name   = "${var.module_var_virtual_server_hostname}-nic-0"
    subnet = local.target_subnet_id
    security_groups = [
      var.module_var_host_security_group_id,
      var.module_var_bastion_connection_security_group_id
    ]
  }

  boot_volume {
    name = "${var.module_var_virtual_server_hostname}-volume-boot-0"
  }

  volumes = flatten([
    var.module_var_disk_volume_type_hana_data == "custom" ? ibm_is_volume.block_volume_hana_data_custom.*.id : ibm_is_volume.block_volume_hana_data_tiered.*.id,
    var.module_var_disk_volume_type_hana_log == "custom" ? ibm_is_volume.block_volume_hana_log_custom.*.id : ibm_is_volume.block_volume_hana_log_tiered.*.id,
    var.module_var_disk_volume_type_hana_shared == "custom" ? ibm_is_volume.block_volume_hana_shared_custom.*.id : ibm_is_volume.block_volume_hana_shared_tiered.*.id,
    ibm_is_volume.block_volume_usr_sap_tiered.*.id,
    ibm_is_volume.block_volume_sapmnt_tiered.*.id,
    ibm_is_volume.block_volume_swap_tiered.*.id,
    ibm_is_volume.block_volume_software_tiered.id
  ])

  //User can configure timeouts
  timeouts {
    create = "90m"
    delete = "30m"
  }

}
