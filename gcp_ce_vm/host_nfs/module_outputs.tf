
# NFS Mount Point
output "output_nfs_fqdn" {
  value = "${google_filestore_instance.file_storage_sapmnt.networks[0].ip_addresses[0]}:/${google_filestore_instance.file_storage_sapmnt.file_shares[0].name}"
}
