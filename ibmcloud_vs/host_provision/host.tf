
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
    allow_ip_spoofing = var.module_var_disable_ip_anti_spoofing // When disable the Anti IP Spoofing = true, then Allow IP Spoofing = true
    security_groups = [
      var.module_var_host_security_group_id,
      var.module_var_bastion_connection_security_group_id
    ]
  }

  boot_volume {
    name = "${var.module_var_virtual_server_hostname}-volume-boot-0"
  }

  metadata_service {
    enabled = true
    protocol = "https"
    response_hop_limit = 5
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}


resource "ibm_is_instance_volume_attachment" "block_volume_attachment" {

  for_each    = ibm_is_volume.block_volume_provision

  instance    = ibm_is_instance.virtual_server.id

  name        = each.value.name
  volume      = each.value.id

  delete_volume_on_attachment_delete = false
  delete_volume_on_instance_delete   = true

}
