
resource "ibm_is_share" "file_storage_sapmnt" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0
  name = "${var.module_var_resource_prefix}-nfs-sapmnt"

  zone = local.target_vpc_availability_zone

  size = 2048
  profile = "dp2"

}

resource "ibm_is_share_mount_target" "file_storage_attach_sapmnt" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0
  name = "${var.module_var_resource_prefix}-nfs-sapmnt-attach"

  share = ibm_is_share.file_storage_sapmnt[0].id
  vpc   = local.target_vpc_id
}
