# Terraform declaration

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      #source  = "localdomain/provider/google" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/google/1.xx.xx/darwin_amd6
      source  = "hashicorp/google" // Terraform Registry
      version = ">=4.50.0"
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


# Terraform Provider declaration

#provider "google" {
#  project     = var.module_var_gcp_project
#  region      = var.module_var_gcp_region
#  zone        = var.module_var_gcp_region_zone
#
#  credentials = file(var.module_var_gcp_credentials_json_path)
#
#}
