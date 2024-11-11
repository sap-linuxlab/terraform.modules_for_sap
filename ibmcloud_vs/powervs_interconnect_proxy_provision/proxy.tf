
# Create Intel Virtual Server

resource "ibm_is_instance" "proxy_virtual_server" {

  resource_group = var.module_var_resource_group_id
  name           = var.module_var_virtual_server_hostname
  profile        = var.module_var_virtual_server_profile

  vpc   = local.target_vpc_id
  zone  = local.target_vpc_availability_zone
  image = data.ibm_is_image.proxy_os_image.id // Must use Image ID
  keys  = [var.module_var_host_ssh_key_id]

  # The Subnet assigned to the legacy primary Network Interface (vNIC) cannot be changed
  # The Name and Security Group assigned are editable
  # primary_network_interface {
  #   name   = "${var.module_var_virtual_server_hostname}-nic-0"
  #   subnet = local.target_subnet_id
  #   security_groups = [
  #     var.module_var_host_security_group_id,
  #     var.module_var_bastion_connection_security_group_id
  #   ]
  # }

  # The Subnet assigned to the primary Virtual Network Interface (VNI) cannot be changed
  # The Name and Security Group assigned are editable
  # Each VNI has a network performance cap of 16 Gbps; this is separate to the network performance cap increment of 2GBps per vCPU
  primary_network_attachment {
    name   = "${var.module_var_virtual_server_hostname}-vni-0-attach"
    virtual_network_interface {
      name = "${var.module_var_virtual_server_hostname}-vni-0"
      resource_group = var.module_var_resource_group_id
      subnet = local.target_subnet_id
      security_groups = [
        var.module_var_host_security_group_id,
        var.module_var_bastion_connection_security_group_id
      ]
      allow_ip_spoofing = false
      enable_infrastructure_nat = false
      protocol_state_filtering_mode = "auto"
      auto_delete = true // will be false if created separately prior to Virtual Server instance
    }
  }

  boot_volume {
    name = "${var.module_var_virtual_server_hostname}-volume-boot-0"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}
