
variable "module_var_resource_group_name" {
  default = "sap-rg"
}

variable "module_var_resource_group_create_boolean" {
}

variable "module_var_resource_prefix" {
  description = "Resource Group and resources prefix"
  default     = "sap"
}

variable "module_var_ibmcloud_vpc_subnet_create_boolean" {
}

variable "module_var_ibmcloud_vpc_subnet_name" {
}

variable "module_var_ibmcloud_region" {
  default = "us-south"
}

variable "module_var_ibmcloud_vpc_availability_zone" {
}

variable "module_var_ibmcloud_api_key" {}
