# Terraform declaration

terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      #source  = "localdomain/provider/ibm" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/ibm/1.xx.xx/darwin_amd6
      source  = "IBM-Cloud/ibm" // Terraform Registry
      version = ">=1.35.0"
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
#  region = var.ibmcloud_region
#
#}
