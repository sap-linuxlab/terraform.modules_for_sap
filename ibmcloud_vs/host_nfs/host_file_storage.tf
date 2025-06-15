
resource "ibm_is_share" "file_storage_sapmnt" {
  name = "${var.module_var_resource_prefix}-nfs-sapmnt"
  resource_group = var.module_var_resource_group_id

  access_control_mode = "vpc"
  zone = local.target_vpc_availability_zone
  size = 2048
  profile = "dp2"

  lifecycle {
    ignore_changes = [ allowed_transit_encryption_modes ]
  }
}

resource "ibm_is_share_mount_target" "file_storage_attach_sapmnt" {
  name = "${var.module_var_resource_prefix}-nfs-sapmnt-attach"

  share = ibm_is_share.file_storage_sapmnt.id
  vpc   = local.target_vpc_id
}


resource "ibm_is_share" "file_storage_transport" {
  name = "${var.module_var_resource_prefix}-nfs-trans"
  resource_group = var.module_var_resource_group_id

  access_control_mode = "vpc"
  zone = local.target_vpc_availability_zone
  size = 2048
  profile = "dp2"

  lifecycle {
    ignore_changes = [ allowed_transit_encryption_modes ]
  }
}

resource "ibm_is_share_mount_target" "file_storage_attach_transport" {
  name = "${var.module_var_resource_prefix}-nfs-trans-attach"

  share = ibm_is_share.file_storage_transport.id
  vpc   = local.target_vpc_id
}
