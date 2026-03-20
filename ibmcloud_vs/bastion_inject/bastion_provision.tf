
# Create Bastion/Jump Host Virtual Server

resource "ibm_is_instance" "bastion_host" {

  resource_group = var.module_var_resource_group_id
  name           = "${var.module_var_resource_prefix}-bastion"
  profile        = "cx2-4x8"
  vpc            = local.target_vpc_id
  zone           = local.target_vpc_availability_zone
  image          = data.ibm_is_image.bastion_os_image.id // Must use Image ID
  keys           = [var.module_var_bastion_ssh_key_id]

  # The Subnet assigned to the legacy primary Network Interface (vNIC) cannot be changed
  # The Name and Security Group assigned are editable
  # primary_network_interface {
  #   name            = "${var.module_var_resource_prefix}-bastion-nic-0"
  #   subnet          = ibm_is_subnet.vpc_bastion_subnet.id
  #   security_groups = [ibm_is_security_group.vpc_sg_bastion.id]
  # }

  # The Subnet assigned to the primary Virtual Network Interface (VNI) cannot be changed
  # The Name and Security Group assigned are editable
  # Each VNI has a network performance cap of 16 Gbps; this is separate to the network performance cap increment of 2GBps per vCPU
  primary_network_attachment {
    name = "${var.module_var_resource_prefix}-bastion-vni-0-attach"
    virtual_network_interface {
      name                          = "${var.module_var_resource_prefix}-bastion-vni-0"
      resource_group                = var.module_var_resource_group_id
      subnet                        = ibm_is_subnet.vpc_bastion_subnet.id
      security_groups               = [ibm_is_security_group.vpc_sg_bastion.id]
      allow_ip_spoofing             = false
      enable_infrastructure_nat     = true // must be true as Virtual Server instances require Infrastructure NAT
      protocol_state_filtering_mode = "auto"
      auto_delete                   = true // if VNI created separately, must be false
    }
  }

  boot_volume {
    name = "${var.module_var_resource_prefix}-bastion-volume-boot-a"
  }

  # Increase operation timeout for Compute and Storage, default to 30m in all Terraform Modules for SAP
  timeouts {
    create = "30m"
    delete = "30m"
  }

}


# Create and attach Floating IP on public internet, to the Bastion/Jump Host Virtual Server
# Enables the Internet to initiate a connection directly with the instance

resource "ibm_is_floating_ip" "bastion_floating_ip" {
  name           = "${var.module_var_resource_prefix}-bastion-floating-ip1"
  target         = ibm_is_instance.bastion_host.primary_network_attachment[0].virtual_network_interface[0].id
  resource_group = var.module_var_resource_group_id
}
