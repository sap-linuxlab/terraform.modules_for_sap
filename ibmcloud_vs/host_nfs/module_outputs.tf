
# Mount path
output "output_nfs_fqdn" {
  value = ibm_is_share_mount_target.file_storage_attach_sapmnt[0].mount_path
}
