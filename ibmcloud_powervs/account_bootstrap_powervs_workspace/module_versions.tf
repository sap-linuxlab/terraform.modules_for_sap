# Terraform declaration

terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      #source  = "localdomain/provider/ibm" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/ibm/1.xx.xx/darwin_amd6
      source  = "IBM-Cloud/ibm" // Terraform Registry
      version = ">=1.45.0"

      # Allowed TF Module child provider names
      configuration_aliases = [
        ibm.main,
        ibm.powervs_secure_enclave
      ]

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

#provider "ibm" {
#
# alias = "standard"
#
# Define Provider inputs manually
#  ibmcloud_api_key = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#
# Define Provider inputs from given Terraform Variables
#  ibmcloud_api_key = var.ibmcloud_api_key
#
# If using IBM Cloud Automation Manager, the Provider declaration values are populated automatically
# from the Cloud Connection credentials (by using Environment Variables)
#
# If using IBM Cloud Schematics, the Provider declaration values are populated automatically
#
#
#  region = local.ibmcloud_region
#
#  zone = lower(var.ibmcloud_powervs_location) // Required for IBM Power VS only
#
#}

# # Terraform Provider (with Alias) declaration - for IBM Power Infrastructure environment via IBM Cloud
# provider "ibm" {
#   alias = "powervs_secure_enclave"
#   ibmcloud_api_key = var.ibmcloud_api_key
#   region = var.map_ibmcloud_powervs_location_to_region[var.ibmcloud_powervs_location] // IBM Power VS Region
#   zone = lower(var.ibmcloud_powervs_location) // IBM Power VS Location
# }
