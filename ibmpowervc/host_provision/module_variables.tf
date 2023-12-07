variable "module_var_resource_prefix" {
}

variable "module_var_ibmpowervc_host_group_name" {
}

variable "module_var_ibmpowervc_network_name" {
}

variable "module_var_ibmpowervc_compute_cpu_threads" {
}

variable "module_var_ibmpowervc_compute_ram_gb" {
}

variable "module_var_ibmpowervc_os_image_name" {
}

variable "module_var_host_ssh_key_name" {
}

variable "module_var_host_public_ssh_key" {
}

variable "module_var_host_private_ssh_key" {
}


variable "module_var_ibmpowervc_template_compute_name" {
}

variable "module_var_ibmpowervc_template_compute_name_create_boolean" {
}

variable "module_var_ibmpowervc_storage_storwize_hostname_short" {
}

variable "module_var_ibmpowervc_storage_storwize_storage_pool" {
}

variable "module_var_ibmpowervc_storage_storwize_storage_pool_flash" {
}


variable "module_var_lpar_hostname" {
  validation {
    condition     = length(var.module_var_lpar_hostname) <= 13
    error_message = "Hostname must be equal to or lower than 13 characters in length."
  }
}

variable "module_var_dns_root_domain_name" {
}

variable "module_var_web_proxy_url" {}
variable "module_var_web_proxy_exclusion" {}

variable "module_var_os_vendor_account_user" {}
variable "module_var_os_vendor_account_user_passcode" {}
variable "module_var_os_systems_mgmt_host" {
  default = ""
}

variable "module_var_storage_definition" {}
