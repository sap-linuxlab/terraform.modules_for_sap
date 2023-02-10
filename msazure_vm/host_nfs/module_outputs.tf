
#output "output_nfs_fqdn" {
#  value = azurerm_storage_share.file_storage_sapmnt[0].url
#}

#output "output_nfs_fqdn_default_public" {
#  value = "${azapi_resource.storage_account_sap[0].name}.file.core.windows.net:/${azapi_resource.storage_account_sap[0].name}/${azapi_resource.file_storage_sapmnt[0].name}"
#}

#output "output_nfs_fqdn_default_private" {
#  value = "${azapi_resource.storage_account_sap[0].name}.privatelink.file.core.windows.net:/${azapi_resource.storage_account_sap[0].name}/${azapi_resource.file_storage_sapmnt[0].name}"
#}

output "output_nfs_fqdn" {
  value = "${azurerm_private_dns_a_record.dns_a_record_short.fqdn}:/${azapi_resource.storage_account_sap[0].name}/${azapi_resource.file_storage_sapmnt[0].name}"
}
