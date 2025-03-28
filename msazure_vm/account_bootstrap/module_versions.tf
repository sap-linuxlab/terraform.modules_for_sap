# Terraform declaration

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      #source  = "localdomain/provider/azurerm" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/azurerm/1.xx.xx/darwin_amd6
      source  = "hashicorp/azurerm" // Terraform Registry
      version = ">=3.108.0"
    }
  }
}


# Terraform Provider declaration
#
# Nested provider configurations cannot be used with depends_on meta-argument between modules
#
# The calling module block can use either:
# - "providers" argument in the module block
# - none, inherit default (un-aliased) provider configuration
#
# Therefore the below is blank and is only for reference if this module needs to be executed manually
#

#provider "azurerm" {
#  features {}
#
#  tenant_id       = var.az_tenant_id  // Azure Tenant ID, linked to the Azure Active Directory instance
#  subscription_id = var.az_subscription_id  // Azure Subscription ID, linked to an Azure Tenant.  All resource groups belong to the Azure Subscription.
#
#  client_id       = var.az_app_client_id  // Azure Client ID, defined in the Azure Active Directory instance; equivalent to Active Directory Application ID.
#  client_secret   = var.az_app_client_secret  // Azure Application ID Password, defined in the Azure Active Directory instance
#
## Role-based Access Control (RBAC) permissions control the actions for resources within the Azure Subscription.
## The Roles are assigned to a Security Principal - which can be a User, Group, Service Principal or Managed Identity.
#
#}
