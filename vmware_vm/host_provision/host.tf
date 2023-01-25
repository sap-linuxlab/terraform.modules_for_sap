
# Cloud-init directive metadata
data "template_file" "cloud_init_metadata" {
  template = file("${path.module}/cloudinit_config_metadata.yml")

  vars = {
    template_var_hostname = var.module_var_vmware_vm_hostname
  }

}

# Cloud-init directive user_data
data "template_file" "cloud_init_user_data" {
  template = file("${path.module}/cloudinit_config_userdata.yml")

  vars = {
    template_var_hostname = var.module_var_vmware_vm_hostname
    template_var_dns_root_domain_name = var.module_var_vmware_vm_dns_root_domain_name
    template_public_key_openssh = var.module_var_host_public_ssh_key
  }

}



resource "vsphere_virtual_machine" "host_provision" {

  depends_on = [
    vsphere_virtual_disk.virtual_disk_hana_data,
    vsphere_virtual_disk.virtual_disk_hana_log,
    vsphere_virtual_disk.virtual_disk_hana_shared,
    vsphere_virtual_disk.virtual_disk_anydb,
    vsphere_virtual_disk.virtual_disk_usr_sap,
    vsphere_virtual_disk.virtual_disk_sapmnt,
    vsphere_virtual_disk.virtual_disk_swap,
    vsphere_virtual_disk.virtual_disk_software
  ]

  name                   = var.module_var_vmware_vm_hostname

  resource_pool_id       = data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id         = data.vsphere_host.host.id

  datastore_id           = data.vsphere_datastore.datastore.id

  folder                 = var.module_var_vmware_vsphere_datacenter_compute_cluster_folder_name

  guest_id               = data.vsphere_virtual_machine.provision_template.guest_id


  # Firmware Interface configuration
  # Required to avoid cloning error "Operating System not found" in VMware vSphere 7.x
  firmware               = data.vsphere_virtual_machine.provision_template.efi_secure_boot_enabled ? "efi" : "bios"
  nested_hv_enabled      = false


  # CPU Processors
  num_cpus               = var.module_var_vmware_vm_compute_cpu_threads
  cpu_hot_add_enabled    = false
  cpu_hot_remove_enabled = false
#  cpu_reservation        = 


  # Memory
  memory                 = abs(var.module_var_vmware_vm_compute_ram_gb * 1024)
  memory_hot_add_enabled = false
#  memory_reservation     = 


  # Storage
  scsi_controller_count  = 1
  scsi_type              = data.vsphere_virtual_machine.provision_template.scsi_type
  enable_disk_uuid       = true


  # Boot disk copied from VMware VM Template
  disk {
    datastore_id      = data.vsphere_datastore.datastore.id
    unit_number       = data.vsphere_virtual_machine.provision_template.disks[0].unit_number
    label             = "${var.module_var_vmware_vm_hostname}-boot"
    size              = data.vsphere_virtual_machine.provision_template.disks[0].size
    thin_provisioned  = data.vsphere_virtual_machine.provision_template.disks[0].thin_provisioned
    eagerly_scrub     = data.vsphere_virtual_machine.provision_template.disks[0].eagerly_scrub
  }


  # Attach Data Volumes to the host
  # Use for loop to create objects with ID and Size, then use the for_each on these objects to populate the content of disk blocks
  dynamic "disk" {

    for_each = [
      for virtual_disks in concat(vsphere_virtual_disk.virtual_disk_hana_data,vsphere_virtual_disk.virtual_disk_hana_log,vsphere_virtual_disk.virtual_disk_hana_shared,vsphere_virtual_disk.virtual_disk_anydb,vsphere_virtual_disk.virtual_disk_usr_sap,vsphere_virtual_disk.virtual_disk_sapmnt,vsphere_virtual_disk.virtual_disk_swap,vsphere_virtual_disk.virtual_disk_software) : {
        path = virtual_disks.vmdk_path
#        size = virtual_disks.size
      }
    ]

    content {
      datastore_id    = data.vsphere_datastore.datastore.id
      unit_number     = disk.key + 1 // Maximum 14 disks per 1 SCSI controller
      label           = "${format("${var.module_var_vmware_vm_hostname}-disk-%03s", disk.key + 1)}"
      ## Use existing Virtual Disk (via vsphere_virtual_disk Terraform Resource)
      attach          = true
      path            = disk.value.path
      ## Inline create new Virtual Disks for the Virtual Machine (no separate Terraform Resources)
      #size            = disk.value.size
      #thin_provisioned
      #eagerly_scrub
    }

  }


  # Network
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.provision_template.network_interface_types[0]
  }


  wait_for_guest_net_timeout = 5 // Timeout for available guest IP address on the virtual machine
  wait_for_guest_ip_timeout  = 5 // Legacy vSphere, Timeout for available guest IP address on the virtual machine


  # VMware 'Clone to Virtual Machine' task
  clone {
    template_uuid = data.vsphere_virtual_machine.provision_template.id
    timeout = 10  // Timeout to complete cloning/provisioning

    customize {

      timeout = 10 // Timeout to complete host configuration

      # linux_options must exist in VM customization options for Linux operating systems
      linux_options {
        host_name = var.module_var_vmware_vm_hostname // Required
        domain    = var.module_var_vmware_vm_dns_root_domain_name // Required
        hw_clock_utc = false
        time_zone = "UTC"
      }

      # Declare network_interface blocks, which are matched to interfaces in sequence
      # To use DHCP, declare an empty network_interface block for each interface
      network_interface {
      }

#      ipv4_gateway    = var.vm_ipv4_gateway
#      dns_suffix_list = "${split(",", var.module_var_vmware_vm_dns_root_domain_name)}"
#
#      # this will to allow to specify multiple values for dns servers
#      dns_server_list = var.vm_dns_servers
    }
  }


  # Please be aware of security concerns when enabling copy/paste from VMware Remote Console (isolation.* parameters)
  extra_config = {
    "isolation.tools.copy.disable" = "FALSE" // Should be uppercase to avoid 'updated in-place' if re-executed
    "isolation.tools.paste.disable" = "FALSE" // Should be uppercase to avoid 'updated in-place' if re-executed
    "isolation.tools.setGUIOptions.enable" = "TRUE" // Should be uppercase to avoid 'updated in-place' if re-executed
    "guestinfo.metadata"          = base64encode(data.template_file.cloud_init_metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.cloud_init_user_data.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }


  # VMware Tools settings for the Virtual Machine
  run_tools_scripts_after_power_on        = true
  run_tools_scripts_after_resume          = false
  run_tools_scripts_before_guest_reboot   = false
  run_tools_scripts_before_guest_shutdown = false
  run_tools_scripts_before_guest_standby  = false


}
