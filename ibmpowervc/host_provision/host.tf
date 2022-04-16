
# Optional: Cloud-init directive user_data
#data "template_file" "cloud_init_user_data" {
#  template = file("${path.module}/optional/cloud_init_config.yml")
#
#  vars = {
#    template_var_lpar_hostname = "${var.module_var_lpar_hostname}"
#    template_var_domain = "${var.module_var_dns_root_domain_name}"
#  }
#
#}


# Create IBM Power LPAR
resource "openstack_compute_instance_v2" "host_provision" {

  name = var.module_var_lpar_hostname

  flavor_id = var.module_var_ibmpowervc_template_compute_name_create_boolean ? openstack_compute_flavor_v2.powervc_compute_template[0].id : data.openstack_compute_flavor_v2.powervc_compute_template_existing[0].id

  image_name = var.module_var_ibmpowervc_os_image_name

  availability_zone_hints = var.module_var_ibmpowervc_host_group_name

  key_pair = var.module_var_host_ssh_key_name

  #security_groups = ["default"]

  network {
    uuid = data.openstack_networking_network_v2.network.network_id
    name = var.module_var_ibmpowervc_network_name
  }

  #user_data = data.template_file.cloud_init_user_data.rendered

}



### Attach Data Volumes to the host

resource "openstack_compute_volume_attach_v2" "volume_attachment_hana_data" {
  count = length(openstack_blockstorage_volume_v2.block_volume_hana_data.*.id)

  instance_id = openstack_compute_instance_v2.host_provision.id
  volume_id   = openstack_blockstorage_volume_v2.block_volume_hana_data[count.index].id
  #multiattach = true
}


resource "openstack_compute_volume_attach_v2" "volume_attachment_hana_log" {
  count = length(openstack_blockstorage_volume_v2.block_volume_hana_log.*.id)

  instance_id = openstack_compute_instance_v2.host_provision.id
  volume_id   = openstack_blockstorage_volume_v2.block_volume_hana_log[count.index].id
  #multiattach = true
}


resource "openstack_compute_volume_attach_v2" "volume_attachment_hana_shared" {
  count = length(openstack_blockstorage_volume_v2.block_volume_hana_shared.*.id)

  instance_id = openstack_compute_instance_v2.host_provision.id
  volume_id   = openstack_blockstorage_volume_v2.block_volume_hana_shared[count.index].id
  #multiattach = true
}


resource "openstack_compute_volume_attach_v2" "volume_attachment_usr_sap" {
  count = length(openstack_blockstorage_volume_v2.block_volume_usr_sap.*.id)

  instance_id = openstack_compute_instance_v2.host_provision.id
  volume_id   = openstack_blockstorage_volume_v2.block_volume_usr_sap[count.index].id
  #multiattach = true
}


resource "openstack_compute_volume_attach_v2" "volume_attachment_sapmnt" {
  count = length(openstack_blockstorage_volume_v2.block_volume_sapmnt.*.id)

  instance_id = openstack_compute_instance_v2.host_provision.id
  volume_id   = openstack_blockstorage_volume_v2.block_volume_sapmnt[count.index].id
  #multiattach = true
}


resource "openstack_compute_volume_attach_v2" "volume_attachment_swap" {
  count = length(openstack_blockstorage_volume_v2.block_volume_swap.*.id)

  instance_id = openstack_compute_instance_v2.host_provision.id
  volume_id   = openstack_blockstorage_volume_v2.block_volume_swap[count.index].id
  #multiattach = true
}


resource "openstack_compute_volume_attach_v2" "volume_attachment_software" {
  instance_id = openstack_compute_instance_v2.host_provision.id
  volume_id   = openstack_blockstorage_volume_v2.block_volume_software.id
  #multiattach = true
}
