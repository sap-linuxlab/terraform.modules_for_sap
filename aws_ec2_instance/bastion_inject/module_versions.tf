# Terraform declaration

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      #source  = "localdomain/provider/aws" // Local, on macOS path to place files would be $HOME/.terraform.d/plugins/localdomain/provider/aws/1.xx.xx/darwin_amd6
      source  = "hashicorp/aws" // Terraform Registry
      version = ">=3.73.0"
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

#provider "aws" {

# Define Provider inputs manually
#  access_key = "xxxxxxx"
#  secret_key = "xxxxxxx"
#  region = "xxxxxxx"

# Define Provider inputs from given Terraform Variables
#  access_key = var.aws_access_key
#  secret_key = var.aws_secret_key
#  region = var.aws_region

#}