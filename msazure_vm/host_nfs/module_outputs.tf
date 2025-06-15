
#output "output_nfs_fqdn" {
#  value = azurerm_storage_share.file_storage_sapmnt.url
#}

#output "output_nfs_fqdn_default_public" {
#  value = "${azapi_resource.storage_account_sap.name}.file.core.windows.net:/${azapi_resource.storage_account_sap.name}/${azapi_resource.file_storage_sapmnt.name}"
#}

#output "output_nfs_fqdn_default_private" {
#  value = "${azapi_resource.storage_account_sap.name}.privatelink.file.core.windows.net:/${azapi_resource.storage_account_sap.name}/${azapi_resource.file_storage_sapmnt.name}"
#}

output "output_nfs_fqdn_sapmnt" {
  value = try("${azurerm_private_dns_a_record.dns_a_record_short.fqdn}:/${azapi_resource.storage_account_sap.name}/${azapi_resource.file_storage_sapmnt.name}","")
}

output "output_nfs_fqdn_transport" {
  value = try("${azurerm_private_dns_a_record.dns_a_record_short.fqdn}:/${azapi_resource.storage_account_sap.name}/${azapi_resource.file_storage_transport.name}","")
}
