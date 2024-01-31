
# Mount path
output "output_nfs_fqdn" {
  value = try(ibm_is_share_mount_target.file_storage_attach_sapmnt[0].mount_path,"")
}
