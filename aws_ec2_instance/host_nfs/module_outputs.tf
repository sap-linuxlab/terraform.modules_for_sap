
output "output_nfs_fqdn_sapmnt" {
  value = try(aws_efs_mount_target.file_storage_attach_sapmnt.mount_target_dns_name,"")
}

output "output_nfs_fqdn_transport" {
  value = try(aws_efs_mount_target.file_storage_attach_transport.mount_target_dns_name,"")
}
