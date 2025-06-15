
# Mount path
output "output_nfs_fqdn_sapmnt" {
  value = try(ibm_is_share_mount_target.file_storage_attach_sapmnt.mount_path,"")
}

output "output_nfs_fqdn_transport" {
  value = try(ibm_is_share_mount_target.file_storage_attach_transport.mount_path,"")
}
