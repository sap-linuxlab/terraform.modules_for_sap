
# NFS Mount Point
output "output_nfs_fqdn_sapmnt" {
  value = "${google_filestore_instance.file_storage_sapmnt.networks[0].ip_addresses[0]}:/${google_filestore_instance.file_storage_sapmnt.file_shares[0].name}"
}

output "output_nfs_fqdn_transport" {
  value = "${google_filestore_instance.file_storage_transport.networks[0].ip_addresses[0]}:/${google_filestore_instance.file_storage_sapmnt.file_shares[0].name}"
}
