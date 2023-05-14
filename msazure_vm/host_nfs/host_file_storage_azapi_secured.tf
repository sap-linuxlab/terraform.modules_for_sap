
resource "random_string" "random_suffix" {
  length      = 6
  min_numeric = 4
  special     = false
  numeric     = false
  lower       = true
  upper       = false
}

data "azurerm_resource_group" "id_lookup" {
  name = var.module_var_az_resource_group_name
}


# Create Azure Storage Account for File Storage

# https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-terraform
resource "azapi_resource" "storage_account_sap" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0

  type = "Microsoft.Storage/storageAccounts@2022-05-01"
  name = "${var.module_var_resource_prefix}stgacc${random_string.random_suffix.result}"
  location = var.module_var_az_location_region
  parent_id = data.azurerm_resource_group.id_lookup.id
  tags = {}
  identity {
    type = "None"
  }
  body = jsonencode({
    sku = {
      name = "Premium_LRS"
    }
    kind = "FileStorage"
    properties = {
      accessTier = "Hot"
      allowBlobPublicAccess = false
      allowCrossTenantReplication = false
      allowSharedKeyAccess = true // Enabled, otherwise Terraform error 'Key based authentication is not permitted on this storage account'
      defaultToOAuthAuthentication = false // Disabled, otherwise Terraform error 'Key based authentication is not permitted on this storage account'
      encryption = {
        keySource = "Microsoft.Storage"  // Allow trusted Microsoft services to access this storage account
        requireInfrastructureEncryption = true // Encryption-at-rest for NFS
        services = {
          blob = {
            enabled = true
            keyType = "Account"
          }
          file = {
            enabled = true
            keyType = "Account"
          }
        }
      }
      isHnsEnabled = false
      isNfsV3Enabled = false // Ensure NFS v4.1 is used
      isSftpEnabled = false
      largeFileSharesState = "Enabled"
      minimumTlsVersion = "TLS1_2"
      networkAcls = {
        bypass = "AzureServices"
        defaultAction = "Deny"
        ipRules = []
        resourceAccessRules = []
        virtualNetworkRules = []
      }
      publicNetworkAccess = "Disabled"
      supportsHttpsTrafficOnly = false // "Secure transfer required" must be disabled, as the NFS protocol does not support encryption and relies on network-level security.
    }
  })
}


# Create Azure Files mount, using disabled Public Network Access

# https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts/fileservices/shares?pivots=deployment-language-terraform
resource "azapi_resource" "file_storage_sapmnt" {
  count = var.module_var_nfs_boolean_sapmnt ? 1 : 0

  type = "Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01"
  name = "${var.module_var_resource_prefix}nfs"
  parent_id = "${azapi_resource.storage_account_sap[0].id}/fileServices/default"
  body = jsonencode({
    properties = {
      accessTier = "Premium"
      enabledProtocols = "NFS"
      shareQuota = 2048  // Maximum GB capacity of NFS
#      metadata = {}
#      rootSquash = "string"
    }
  })
}



#data "azapi_resource" "data_storage_account" {
#  type       = "Microsoft.Storage/storageAccounts@2022-05-01"
#  name       = "${var.module_var_resource_prefix}stgacc${random_string.random_suffix.result}"
#  parent_id  = data.azurerm_resource_group.id_lookup.id
#}

#data "azapi_resource" "data_storage_account_file_service" {
#  type       = "Microsoft.Storage/storageAccounts/fileServices@2022-05-01"
#  name       = "default"
#  parent_id  = "${azapi_resource.storage_account_sap[0].id}"
#}

#data "azapi_resource" "data_storage_account_file_service_shares" {
#  type       = "Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01"
#  name       = azapi_resource.file_storage_sapmnt.name
#  parent_id  = "${azapi_resource.storage_account_sap[0].id}/fileServices/default"
#}

