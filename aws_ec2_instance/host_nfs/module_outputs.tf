
output "output_nfs_fqdn" {
  value = aws_efs_mount_target.file_storage_attach_sapmnt[0].mount_target_dns_name
}
